class Mysqltuner < Formula
  desc "Increase performance and stability of a MySQL installation"
  homepage "http://mysqltuner.com"
  url "https://github.com/major/MySQLTuner-perl/archive/1.6.0.tar.gz"
  sha256 "dc3045b9ffae7837d187d2b1ef4c42648bf7ffc6bb9f69864a4bfeecd5205e37"
  head "https://github.com/major/MySQLTuner-perl.git"

  bottle :unneeded

  def install
    bin.install "mysqltuner.pl" => "mysqltuner"
  end

  # mysqltuner analyzes your database configuration by connecting to a
  # mysql server. It is not really feasible to spawn a mysql server
  # just for a test case so we'll stick with a rudimentary test.
  test do
    system "#{bin}/mysqltuner", "--help"
  end
end
