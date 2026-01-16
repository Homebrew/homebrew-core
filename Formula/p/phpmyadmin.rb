class Phpmyadmin < Formula
  desc "Web interface for MySQL and MariaDB"
  homepage "https://www.phpmyadmin.net"
  url "https://files.phpmyadmin.net/phpMyAdmin/5.2.3/phpMyAdmin-5.2.3-all-languages.tar.gz"
  sha256 "12ba1c425fa4071abbd4e7668c9ebdeac0b0755a467a6d6d5026122bb47c102b"
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
    sha256 cellar: :any_skip_relocation, all: "2047290d2b40a179ad79f4ed3890ebcbb5a6177c6f5279f55d8d41e866a1111a"
  end

  depends_on "php" => :test

  def install
    # Make bottles uniform
    usr_local_files = %w[
      libraries/classes/Plugins/Transformations/Abs/ExternalTransformationsPlugin.php
      vendor/composer/ca-bundle/src/CaBundle.php
      vendor/tecnickcom/tcpdf/tcpdf_autoconfig.php
      vendor/thecodingmachine/safe/generated/info.php
      vendor/thecodingmachine/safe/generated/pcntl.php
    ]
    inreplace usr_local_files, "/usr/local", HOMEBREW_PREFIX
    inreplace "vendor/composer/ca-bundle/src/CaBundle.php", "/opt/homebrew", HOMEBREW_PREFIX

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
    php = Formula["php"].opt_bin/"php"
    cd pkgshare do
      assert_match "German", shell_output("#{php} #{pkgshare}/index.php")
    end
  end
end
