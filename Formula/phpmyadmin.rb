class Phpmyadmin < Formula
  desc "Web interface for MySQL and MariaDB"
  homepage "https://www.phpmyadmin.net"
  url "https://files.phpmyadmin.net/phpMyAdmin/5.2.0/phpMyAdmin-5.2.0-all-languages.tar.gz"
  sha256 "f794528eebf1b723a29b89d239963e979a251fb484fd6e788919bf8cbca7db39"

  livecheck do
    url "https://www.phpmyadmin.net/files/"
    regex(/href=.*?phpMyAdmin[._-]v?(\d+(?:\.\d+)+)-all-languages\.zip["' >]/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "287dd994aff3570f5bd32f7fb4fb670e8bb76b68774e60d60a536adc54a5c03c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "287dd994aff3570f5bd32f7fb4fb670e8bb76b68774e60d60a536adc54a5c03c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "287dd994aff3570f5bd32f7fb4fb670e8bb76b68774e60d60a536adc54a5c03c"
    sha256 cellar: :any_skip_relocation, ventura:        "68045778c9ed100dd22374199cb1c1d9f089fe78253ce976d00fbbdc01ea42cd"
    sha256 cellar: :any_skip_relocation, monterey:       "68045778c9ed100dd22374199cb1c1d9f089fe78253ce976d00fbbdc01ea42cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "68045778c9ed100dd22374199cb1c1d9f089fe78253ce976d00fbbdc01ea42cd"
    sha256 cellar: :any_skip_relocation, catalina:       "68045778c9ed100dd22374199cb1c1d9f089fe78253ce976d00fbbdc01ea42cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "287dd994aff3570f5bd32f7fb4fb670e8bb76b68774e60d60a536adc54a5c03c"
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
