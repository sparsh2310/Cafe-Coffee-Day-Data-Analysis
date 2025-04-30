select * from coffee_shop_sales;

-- dateset: https://drive.google.com/drive/folders/14sSwndELBWmfsBZc5E3dnc4VrgOCemcz
-- this data contain update and alter  function

describe coffee_shop_sales; 

-- 1 TOTAL SALES:
select round(sum(transaction_qty * unit_price),2)as Total_Sales  from coffee_shop_sales;
select round(sum(transaction_qty * unit_price),2)as Total_Sales  from coffee_shop_sales
where month(transaction_date) = 5;




-- 2.TOTAL SALES KPI - MOM DIFFERENCE AND MOM GROWTH:
select * from coffee_shop_sales;

select month(transaction_date) as No_of_Month, 
round(sum(unit_price * transaction_qty),2) as Total_sales,
(sum(transaction_qty * unit_price) - lag(sum(transaction_qty * unit_price),1)
over(order by month( transaction_date)))/ lag(sum(transaction_qty * unit_price),1)
over(order by month( transaction_date)) * 100 as Percentage_sales_MoM 
from coffee_shop_sales
where month(transaction_date) in (4,5) 
group by   MONTH(transaction_date)
order by month(transaction_date);




-- 3. TOTAL ORDERS:
select count(transaction_id)  as Total_qty_sold from coffee_shop_sales;

select count(transaction_id)  as Total_qty_sold from coffee_shop_sales
where month(transaction_date) in (4,5,2); -- for 2 month or more months

select count(transaction_id) as Total_qty_sold from coffee_shop_sales
where month(transaction_date) = 5;




-- 4.TOTAL ORDERS KPI - MOM DIFFERENCE AND MOM GROWTH:
select month(transaction_date) as Month,
count(transaction_id) as Total_order,
(count(transaction_id) - lag(count(transaction_id),1)
over(order by  month(transaction_date)))/ lag(count(transaction_id),1)
over(order by  month(transaction_date)) * 100 as Percentage_order_MOM
 from coffee_shop_sales
 where month(transaction_date) in (4,5)
 group by 1
 order by 1;

-- 5.TOTAL QUANTITY SOLD
select sum(transaction_qty)  as Total_qty_sold from coffee_shop_sales;

select sum(transaction_qty)  as Total_qty_sold from coffee_shop_sales
where month(transaction_date) in (4,5,2); -- for 2 month or more months

select sum(transaction_qty) as Total_qty_sold from coffee_shop_sales
where month(transaction_date) = 5;

-- 6. TOTAL QUANTITY SOLD KPI - MOM DIFFERENCE AND MOM GROWTH
select month(transaction_date) as Month,
sum(transaction_qty) as Total_order,
(sum(transaction_qty) - lag(sum(transaction_qty),1)
over(order by  month(transaction_date)))/ lag(sum(transaction_qty),1)
over(order by  month(transaction_date)) * 100 as Percentage_order_MOM
 from coffee_shop_sales
 where month(transaction_date) in (4,5)
 group by 1
 order by 1;


-- 7.CALENDAR TABLE – DAILY SALES, QUANTITY and TOTAL ORDERS

select * from coffee_shop_sales;


select month(transaction_date),count(transaction_id) as Total_Order,sum(transaction_qty) as Total_Quantity,sum(unit_price * transaction_qty) as Total_Sales from coffee_shop_sales
where month(transaction_date)=5 -- for month
group by month(transaction_date);

select count(transaction_id) as Total_Order,sum(transaction_qty) as Total_Quantity,sum(unit_price * transaction_qty) as Total_Sales from coffee_shop_sales
where transaction_date= '2023-05-18';  -- for date

-- for Daliy sales

SELECT 
    DATE(transaction_date) as Date,
    COUNT(transaction_id) AS Total_Order_Taken,
    SUM(transaction_qty) AS Total_Quantity_sold,
    SUM(unit_price * transaction_qty) AS Total_Sales
FROM
    coffee_shop_sales
group by date(transaction_date);


SELECT
    SUM(unit_price * transaction_qty) AS total_sales,
    SUM(transaction_qty) AS total_quantity_sold,
    COUNT(transaction_id) AS total_orders
FROM 
    coffee_shop_sales
WHERE 
    transaction_date = '2023-05-18'; -- For 18 May 2023





-- 8.SALES TREND OVER PERIOD -- doubt

select sum(transaction_qty * unit_price) as Total_Sales from coffee_shop_sales
where dayofmonth(transaction_date)= 5;

-- avg sales over period:

select avg(transaction_qty * unit_price)from coffee_shop_sales
where month(transaction_date)= 5;

-- or

select avg(total_sales) as Average_sales from
(
select sum(transaction_qty * unit_price) as total_sales from coffee_shop_sales
where month(transaction_date)= 5
group by transaction_date) as internal;



-- 9.DAILY SALES FOR MONTH SELECTED

select day(transaction_date) as Day_of_month, sum(transaction_qty * unit_price) as total_sales from coffee_shop_sales
where month(transaction_date) = 5
group by day(transaction_date)
; 

-- COMPARING DAILY SALES WITH AVERAGE SALES – IF GREATER THAN “ABOVE AVERAGE” and LESSER THAN “BELOW AVERAGE”

select day_of_month,	
		case 
				when total_sale>avg_sale then 'Above Average'
                when total_sale<avg_sale then 'Below Average'
                else 'Average'
		end As Sales_status
         from
        
        (select day(transaction_date) as day_of_month,
        sum(transaction_qty *unit_price ) as total_sale,
        AVG(SUM(unit_price * transaction_qty)) OVER () AS avg_sale -- not understand
        from coffee_shop_sales
        where month(transaction_date) = 5
        group by day(transaction_date)) as sales_data;


-- 10.SALES BY WEEKDAY / WEEKEND:

select  
			case
            when dayofweek(transaction_date) in (1,7) then 'Weekend'
            else 'Weekday'
            end as Day_status ,
            round(sum(transaction_qty *unit_price ),2) as Total_sales
            from coffee_shop_sales
            where month(transaction_date) =5
            group by 1;
            
            
-- 11. SALES BY STORE LOCATION:
select * from coffee_shop_sales;

select store_location,concat('$',round((sum(transaction_qty *unit_price)),2)) as Total_Sales 
from coffee_shop_sales
group by store_location
order by 2;






-- 12. SALES BY PRODUCT CATEGORY:
select product_category,sum(transaction_qty *unit_price) as Total_Sales 
from coffee_shop_sales
where month(transaction_date)
group by product_category
order by 2;





-- 13.SALES BY PRODUCTS (TOP 10):

select product_category,concat('$ ',round((sum(transaction_qty *unit_price)),2)) as Total_Sales
from coffee_shop_sales
group by product_category
order by 2 desc limit 10;

-- 14.SALES BY DAY | HOUR:
select sum(transaction_qty *unit_price) as Total_Sales ,sum(transaction_qty) as Quantity 
from coffee_shop_sales
where dayofweek(transaction_date) = 3
and hour(transaction_time)=8
and month(transaction_date)=5;


-- 15. TO GET SALES FOR ALL HOURS FOR MONTH OF MAY :
select hour(transaction_time) as Sales_by_hour,
sum(transaction_qty * unit_price) as Total_sales from coffee_shop_sales
where month(transaction_date)=5
group by 1
order by 1;


-- Advanced queries

-- 1. Sales Performance by Product (Most Popular Items)
-- To identify which products (e.g., coffee, pastries) are sold the most:

select product_type as Best_Product ,dayofweek(transaction_date) as Day_of_Week,
sum(transaction_qty * unit_price) as Total_sales
 from coffee_shop_sales
 group by product_type, dayofweek(transaction_date)
 order by dayofweek(transaction_date) desc limit 5;

-- 2. Total Sales for Each Product:
select product_type as Product, 
sum(transaction_qty * unit_price) as Total_sales
from coffee_shop_sales
group by product_type;







-- 3. Top Products by Sales in a Specific Period (Last 30 Days)
-- This query ranks the products based on their total sales over the last 30 days.

SELECT 
    product_id,
sum(transaction_qty * unit_price) as Total_sales
FROM 
    coffee_shop_sales
WHERE 
    transaction_date >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY  1
ORDER BY 
    2 DESC;
    

-- 4. Sales by Day and Time (Morning vs. Afternoon) for particular day of week
select hour(transaction_time) as hour_of_Day, 
		case
       
        when hour(transaction_time)>12 and hour(transaction_time)< 16 then 'Afternoon Orders'
        when hour(transaction_time)>=16 and hour(transaction_time)<24 then 'Evening Orders'
        else 'Morning Order'
        end as Order_time,
        round(sum(transaction_qty * unit_price),2) as Total_sales

from coffee_shop_sales
where dayofweek(transaction_date)=6
group  by 2,1
order by 1;

select hour(transaction_time) from coffee_shop_sales;

describe coffee_shop_sales;
