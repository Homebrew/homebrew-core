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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bfd3b06a94a0a347fbd5867091eacb91f18b28580f28da8fbccd59fe53457a73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfd3b06a94a0a347fbd5867091eacb91f18b28580f28da8fbccd59fe53457a73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfd3b06a94a0a347fbd5867091eacb91f18b28580f28da8fbccd59fe53457a73"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a26dd35fa9ff398d8c6f69f332764f845d81e7f9b149e04783847f4a4236964"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a26dd35fa9ff398d8c6f69f332764f845d81e7f9b149e04783847f4a4236964"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a26dd35fa9ff398d8c6f69f332764f845d81e7f9b149e04783847f4a4236964"
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
