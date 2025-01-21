class Phpmyadmin < Formula
  desc "Web interface for MySQL and MariaDB"
  homepage "https://www.phpmyadmin.net"
  url "https://files.phpmyadmin.net/phpMyAdmin/5.2.1/phpMyAdmin-5.2.1-all-languages.tar.gz"
  sha256 "61c763f209817d1b5d96a4c0eab65b4e36bce744f78e73bef3bebd1c07481c46"
  license all_of: [
    "GPL-2.0-only",
    "GPL-2.0-or-later",
    "BSD-2-Clause",
    "BSD-3-Clause",
    "CC-BY-3.0",
    "ISC",
    "LGPL-3.0-only",
    "MIT",
    "MPL-2.0",
    :public_domain,
  ]

  livecheck do
    url "https://www.phpmyadmin.net/files/"
    regex(/href=.*?phpMyAdmin[._-]v?(\d+(?:\.\d+)+)-all-languages\.zip["' >]/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "639600846a9d3e93308a58896d6e08239f82c7a76f117ac664561647d98feb97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "639600846a9d3e93308a58896d6e08239f82c7a76f117ac664561647d98feb97"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "639600846a9d3e93308a58896d6e08239f82c7a76f117ac664561647d98feb97"
    sha256 cellar: :any_skip_relocation, sonoma:        "995e2b5ae053275953d667a4dfb1ef757cb2fb493eba23f16f2fecc35d668fc2"
    sha256 cellar: :any_skip_relocation, ventura:       "995e2b5ae053275953d667a4dfb1ef757cb2fb493eba23f16f2fecc35d668fc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "639600846a9d3e93308a58896d6e08239f82c7a76f117ac664561647d98feb97"
  end

  depends_on "php@8.3" => :test

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
    php = Formula["php@8.3"].opt_bin/"php"
    cd pkgshare do
      assert_match "German", shell_output("#{php} #{pkgshare}/index.php")
    end
  end
end
