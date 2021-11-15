class Phpmyadmin < Formula
  desc "Web interface for MySQL and MariaDB"
  homepage "https://www.phpmyadmin.net"
  url "https://files.phpmyadmin.net/phpMyAdmin/5.1.1/phpMyAdmin-5.1.1-all-languages.tar.gz"
  sha256 "8264b57aeaa1f91c6d859331777c71e80d26088bef7cdcd5f9431119747ed1c1"

  livecheck do
    url "https://www.phpmyadmin.net/files/"
    regex(/href=.*?phpMyAdmin[._-]v?(\d+(?:\.\d+)+)-all-languages\.zip["' >]/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f08308ccb87cc6aee145cccb50e07755b88a020c3b589770d9c28d320d11c73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9a046e5d63966741a5dc84e52af4b6cce94cada8bcc445e847bc2d9727623ad"
    sha256 cellar: :any_skip_relocation, monterey:       "edc6b2459958163c74314a8713841ab5ea2a9464d7d032e7c48e0f44bd31c236"
    sha256 cellar: :any_skip_relocation, big_sur:        "3cfa3633d65f13cc01ea68e30138f4cba9d11f0f2335db7c92b49e441e80e76f"
    sha256 cellar: :any_skip_relocation, catalina:       "3cfa3633d65f13cc01ea68e30138f4cba9d11f0f2335db7c92b49e441e80e76f"
    sha256 cellar: :any_skip_relocation, mojave:         "3cfa3633d65f13cc01ea68e30138f4cba9d11f0f2335db7c92b49e441e80e76f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f08308ccb87cc6aee145cccb50e07755b88a020c3b589770d9c28d320d11c73"
  end

  depends_on "php" => :test

  def install
    pkgshare.install Dir["*"]

    etc.install pkgshare/"config.sample.inc.php" => "phpmyadmin.config.inc.php"
    ln_s etc/"phpmyadmin.config.inc.php", pkgshare/"config.inc.php"
  end

  def caveats
    <<~EOS
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
