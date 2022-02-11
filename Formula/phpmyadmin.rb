class Phpmyadmin < Formula
  desc "Web interface for MySQL and MariaDB"
  homepage "https://www.phpmyadmin.net"
  url "https://files.phpmyadmin.net/phpMyAdmin/5.1.3/phpMyAdmin-5.1.3-all-languages.tar.gz"
  sha256 "7a85454d82d88cc1a6beb09114a67fa40230c4eff2ae1778b434fa74e80dc6d7"

  livecheck do
    url "https://www.phpmyadmin.net/files/"
    regex(/href=.*?phpMyAdmin[._-]v?(\d+(?:\.\d+)+)-all-languages\.zip["' >]/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c76323b81f1045b6a298cf79806530820f6fa280079e6e5c8f63130925920f08"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c76323b81f1045b6a298cf79806530820f6fa280079e6e5c8f63130925920f08"
    sha256 cellar: :any_skip_relocation, monterey:       "00781d9192496bc829104fa222dfb8cf4238326948020667cba18c83c82d831b"
    sha256 cellar: :any_skip_relocation, big_sur:        "00781d9192496bc829104fa222dfb8cf4238326948020667cba18c83c82d831b"
    sha256 cellar: :any_skip_relocation, catalina:       "00781d9192496bc829104fa222dfb8cf4238326948020667cba18c83c82d831b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c76323b81f1045b6a298cf79806530820f6fa280079e6e5c8f63130925920f08"
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
