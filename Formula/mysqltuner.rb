class Mysqltuner < Formula
  desc "Increase performance and stability of a MySQL installation"
  homepage "https://raw.github.com/major/MySQLTuner-perl/master/mysqltuner.pl"
  url "https://github.com/major/MySQLTuner-perl/archive/1.7.2.tar.gz"
  sha256 "f2d8dcf588cfb8d9351e44d64d14dd2d306c5b599d0b7cada98b53c4f0ec48ec"
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
