class Mysqltuner < Formula
  desc "Increase performance and stability of a MySQL installation"
  homepage "https://raw.github.com/major/MySQLTuner-perl/master/mysqltuner.pl"
  url "https://github.com/major/MySQLTuner-perl/archive/refs/tags/v1.9.9.tar.gz"
  sha256 "f5a8ef9486977dd7e73ef5d53a1a0bf7f3cc7bf9ba9f9f4368454352cd0f881a"
  license "GPL-3.0-or-later"
  head "https://github.com/major/MySQLTuner-perl.git", branch: "master"

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
