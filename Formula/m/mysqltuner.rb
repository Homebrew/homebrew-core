class Mysqltuner < Formula
  desc "Increase performance and stability of a MySQL installation"
  homepage "https://mysqltuner.com/"
  url "https://github.com/jmrenouard/MySQLTuner-perl/archive/refs/tags/v2.8.42.tar.gz"
  sha256 "9213294f23aac2658d9a0f0fb3984edc3eff75f92d159d4c240f8fab89ff1537"
  license "GPL-3.0-or-later"
  head "https://github.com/jmrenouard/MySQLTuner-perl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3afe2ad5e409a38d593c55e98f3e55c41a1e10fd653fcd0ba3ce5381c5b9be06"
  end

  def install
    bin.install "mysqltuner.pl" => "mysqltuner"
  end

  # mysqltuner analyzes your database configuration by connecting to a
  # mysql server. It is not really feasible to spawn a mysql server
  # just for a test case so we'll stick with a rudimentary test.
  test do
    system bin/"mysqltuner", "--help"
  end
end
