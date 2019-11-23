class Phpmyadmin < Formula
  desc "Web interface for MySQL and MariaDB"
  homepage "https://www.phpmyadmin.net"
  url "https://files.phpmyadmin.net/phpMyAdmin/4.9.2/phpMyAdmin-4.9.2-all-languages.tar.gz"
  sha256 "82d1f846cb4bd29a9f2827527958db11df948c5e32b56c7b06f4f8b7dad81450"

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
