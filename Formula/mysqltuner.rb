class Mysqltuner < Formula
  desc "Increase performance and stability of a MySQL installation"
  homepage "https://raw.github.com/major/MySQLTuner-perl/master/mysqltuner.pl"
  url "https://github.com/major/MySQLTuner-perl/archive/1.8.3.tar.gz"
  sha256 "9b8b1dff03550f03c659d2b850cb287d784f0d79f193c1d8a969516cc44738cb"
  license "GPL-3.0-or-later"
  head "https://github.com/major/MySQLTuner-perl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11245f159d339a4e3df8759f3e71e15ead6a6388b9c4711b3b9c3cdc7480b535"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11245f159d339a4e3df8759f3e71e15ead6a6388b9c4711b3b9c3cdc7480b535"
    sha256 cellar: :any_skip_relocation, monterey:       "b120b6a66070df0ef336ba1fbc5ecb419d95a80c688307370681fed4d3534083"
    sha256 cellar: :any_skip_relocation, big_sur:        "b120b6a66070df0ef336ba1fbc5ecb419d95a80c688307370681fed4d3534083"
    sha256 cellar: :any_skip_relocation, catalina:       "b120b6a66070df0ef336ba1fbc5ecb419d95a80c688307370681fed4d3534083"
    sha256 cellar: :any_skip_relocation, mojave:         "b120b6a66070df0ef336ba1fbc5ecb419d95a80c688307370681fed4d3534083"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11245f159d339a4e3df8759f3e71e15ead6a6388b9c4711b3b9c3cdc7480b535"
  end

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
