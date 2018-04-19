class Phpmyadmin < Formula
  desc "Web interface for MySQL and MariaDB"
  homepage "https://www.phpmyadmin.net"
  url "https://files.phpmyadmin.net/phpMyAdmin/4.8.0/phpMyAdmin-4.8.0-all-languages.tar.gz"
  sha256 "1e83d60627d8036261af71220eae9ffd8d3150778702720905bcfa85c40ce346"
  head "https://github.com/phpmyadmin/phpmyadmin.git"

  depends_on "php" => :test

  def install
    pkgshare.install Dir["*"]

    unless File.exist?(etc+"phpmyadmin.config.inc.php")
      cp (pkgshare+"config.sample.inc.php"), (etc+"phpmyadmin.config.inc.php")
    end
    ln_s (etc+"phpmyadmin.config.inc.php"), (pkgshare+"config.inc.php")
  end

  def caveats; <<~EOS
    Note that this formula will NOT install mysql. It is not
    required since you might want to get connected to a remote
    database server.

    Webserver configuration example (add this at the end of
    your /etc/apache2/httpd.conf for instance) :
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
    Then, open http://localhost/phpmyadmin

    More documentation : file://#{pkgshare}/doc/

    Configuration has been copied to #{etc}/phpmyadmin.config.inc.php
    Don't forget to:
      - change your secret blowfish
      - uncomment the configuration lines (pma, pmapass ...)

    EOS
  end

  test do
    assert_predicate etc/"phpmyadmin.config.inc.php", :exist?

    Dir.chdir(pkgshare)
    system "php", pkgshare/"index.php"
  end
end
