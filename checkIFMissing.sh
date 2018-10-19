#!/usr/bin/ksh
#This shell sends error message if there is a record in TABLE_A that is NOT IN TABLE_B. (Using a DBLink)
#TABLE_B has as key an INTEGER value while TABLE_A has as key a VARCHAR value.
#
#Example:
#
#TABLE_B.ID = 1234
#TABLE_A.ID = '1234'

umask 111
. $HOME/ .bash_profile

# executing the Oracle statement, PL/SQL, and store the result in a variable

MISSING_CT =`sqlplus -silent ${OracleConxInf} << eof
    set feedback off echo off heading off
    
    SELECT  count(*) 
    FROM TABLE_A@MY.DBLINK.COM as a
        WHERE CAST(a.ID AS INTEGER) NOT IN (
            SELECT TABLE_B.ID FROM SCHEMA.TABLE_B)
    /
    eof`



echo NUMBER OF MISSING RECORDS = $MISSING_CT 


if ["$MISSING_CT" == 0]; THEN
    echo "There is not Missing records"

EXIT 0
ELSE
    echo NUMBER OF MISSING RECORDS = $MISSING_CT
    EXIT 1
fi