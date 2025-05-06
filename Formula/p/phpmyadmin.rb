class Phpmyadmin < Formula
  desc "Web interface for MySQL and MariaDB"
  homepage "https://www.phpmyadmin.net"
  url "https://files.phpmyadmin.net/phpMyAdmin/5.2.2/phpMyAdmin-5.2.2-all-languages.tar.gz"
  sha256 "8551c8bf3b166f232d5cf64bac877472e9d0cb8f2fe1858fab24f975e7d765b6"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93d7d0a1972beb0f25710049a6a9397be080440c3f8aec1c43b151607133f6f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93d7d0a1972beb0f25710049a6a9397be080440c3f8aec1c43b151607133f6f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "93d7d0a1972beb0f25710049a6a9397be080440c3f8aec1c43b151607133f6f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "82e7df63e44dff329d37ab987bdee2415dea8c4ac14fb636e80ab471860d958a"
    sha256 cellar: :any_skip_relocation, ventura:       "82e7df63e44dff329d37ab987bdee2415dea8c4ac14fb636e80ab471860d958a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2dea00945d920af4a076e5034ac58a13bc88821298828068a4d35da29bc96ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2dea00945d920af4a076e5034ac58a13bc88821298828068a4d35da29bc96ef"
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
