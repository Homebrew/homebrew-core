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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8128020d81fb88ccf3a6f6d8237c51ed2a1a19834539fa9b2303d5feaff22667"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb34ea7ccef57d1f9a45841b4dc4bd8a6d483611bc4aeaa4d5ddfda417005864"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3bd02506f7741f5c566ce1208327f2a2cf02e2295d4cb5cadb6f9f2c4fafb8ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2545dca90ee52f478275ff1a0da76cf27fcaf20fa7071f5cfe00f2c7fcdf1f7a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83753db830be44e9d0b476e3fbb02ccabf9673364da6c9af9a15909d790acaf5"
    sha256 cellar: :any_skip_relocation, sonoma:         "af9fe78d82eedac1e56a34dc09d2f15aaeecba6dd21f8c51706afce6cd0c6170"
    sha256 cellar: :any_skip_relocation, ventura:        "15496fab9c4d8744f5d69869e0862a9c3ea957ebb1c3e62c6f02b7a8ba810169"
    sha256 cellar: :any_skip_relocation, monterey:       "d0e69d5885b6c7a0e34214d6f3f5ef1aa982c913a239ff3e71c1b4ac6732e701"
    sha256 cellar: :any_skip_relocation, big_sur:        "77e2cb701aaf85ea94c8e1c9b9345fb6bd6ef6f6ec51a956eed2e3d81895cd21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3db06f5c804f3bdc48368d1d1b6460d093163fed7cd881fcdae06d14ee3c53d6"
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
