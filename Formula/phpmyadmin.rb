class Phpmyadmin < Formula
  desc "Web interface for MySQL and MariaDB"
  homepage "https://www.phpmyadmin.net"
  url "https://files.phpmyadmin.net/phpMyAdmin/4.8.1/phpMyAdmin-4.8.1-all-languages.tar.gz"
  sha256 "4f7771e96a1637797e0dc710d36345d8327a612d8c08ac305018ef7185f2217d"

  bottle :unneeded

  depends_on "php" => :test

  def install
    pkgshare.install Dir["*"]

    etc.install pkgshare/"config.sample.inc.php" => "phpmyadmin.config.inc.php"
    ln_s etc/"phpmyadmin.config.inc.php", pkgshare/"config.inc.php"
  end

  test do
    cd pkgshare do
      assert_match "German", shell_output("php #{pkgshare}/index.php")
    end
  end
end
