class Mysqltuner < Formula
  desc "Increase performance and stability of a MySQL installation"
  homepage "http://mysqltuner.com"
  url "https://github.com/major/MySQLTuner-perl/archive/1.6.18.tar.gz"
  sha256 "ae2b2668198fb78a7685fc4a372bafcef0a91b1dca15d065dae73eeb74bcd6cb"
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
