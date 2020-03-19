#!/bin/sh
apt update 
apt upgrade
apt install apache2
apt install git
echo apache-version
#read -p "click enter to continue on to the next step"
apt-get install ufw
ufw allow 'Apache'
systemctl restart apache2 &
systemctl status apache2 &
sudo mkdir -p /var/www/gracetalk.org/
sudo chown -R $USER:$USER /var/www/gracetalk.org/
sudo chmod -R 755 /var/www/gracetalk.org
cd /var/www/gracetalk.org
git init 
git remote add origin https://github.com/werty669/dadWeb.git
git pull origin master
touch ./sync.sh
echo "#!/bin/bash
      git pull origin master
      exit" >> sync.sh
chmod 755 sync.sh
touch /etc/apache2/sites-available/gracetalk.org.conf
echo "<VirtualHost *:80>
	ServerAdmin admin@gracetalk.org
	ServerName gracetalk.org
	ServerAlias www.gracetalk.org
	DocumentRoot /var/www/gracetalk.org
	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>" >> /etc/apache2/sites-available/caden.local.conf
sudo a2ensite gracetalk.org.conf
sudo a2dissite 000-default.conf
sudo systemctl restart apache2
sudo apache2ctl configtest
wait -n 5 ./sync.sh
exit
