class Mysqltuner < Formula
  desc "Increase performance and stability of a MySQL installation"
  homepage "https://mysqltuner.com/"
  url "https://github.com/jmrenouard/MySQLTuner-perl/archive/refs/tags/v2.9.4.tar.gz"
  sha256 "8732ea93f2e382463f368fcd8e0445659856371d828262e85e9690e3f43b8f40"
  license "GPL-3.0-or-later"
  head "https://github.com/jmrenouard/MySQLTuner-perl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "71df025f9a4ee674fa29118e019bba2bf5f2dfe0e881dd77f8dda73f1e8888af"
    sha256 cellar: :any_skip_relocation, all: "2a13257351682b1d2f1aafab11fbf070804786fd68e0a9634c1cdffcb702a784"
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
