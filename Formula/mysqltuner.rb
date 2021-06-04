class Mysqltuner < Formula
  desc "Increase performance and stability of a MySQL installation"
  homepage "https://raw.github.com/major/MySQLTuner-perl/master/mysqltuner.pl"
  url "https://github.com/major/MySQLTuner-perl/archive/1.7.21.tar.gz"
  sha256 "b6e39f0768a132bca59708f4d7b0edba935a0f59bbb3ac38023d5835f7563caa"
  license "GPL-3.0-or-later"
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
