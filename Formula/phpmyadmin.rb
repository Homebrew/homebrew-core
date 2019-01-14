class Phpmyadmin < Formula
  desc "Web interface for MySQL and MariaDB"
  homepage "https://www.phpmyadmin.net"
  url "https://files.phpmyadmin.net/phpMyAdmin/4.8.4/phpMyAdmin-4.8.4-all-languages.tar.gz"
  sha256 "4716ad8d0e2fb74f01adc32b7aa0dedcadf6671346a74a521182f62ae8954880"

  bottle :unneeded

  depends_on "php" => :test

  def install
    pkgshare.install Dir["*"]

    etc.install pkgshare/"config.sample.inc.php" => "phpmyadmin.config.inc.php"
    ln_s etc/"phpmyadmin.config.inc.php", pkgshare/"config.inc.php"
  end

  def caveats; <<~EOS
    To enable phpMyAdmin in Apache, add the following to httpd.conf and
    restart Apache:
        Alias /phpmyadmin #{HOMEBREW_PREFIX}/share/phpmyadmin
        <Directory #{HOMEBREW_PREFIX}/share/phpmyadmin/>
            Options Indexes FollowSymLinks MultiViews
            AllowOverride All
            <IfModule mod_authz_core.c>
                Require all granted
            </IfModule>
            <IfModule !mod_authz_core.c>
                Order allow,deny
                Allow from all
            </IfModule>
        </Directory>
    Then open http://localhost/phpmyadmin
    The configuration file is #{etc}/phpmyadmin.config.inc.php
  EOS
  end

  test do
    cd pkgshare do
      assert_match "German", shell_output("php #{pkgshare}/index.php")
    end
  end
end
