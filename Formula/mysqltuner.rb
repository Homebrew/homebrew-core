class Mysqltuner < Formula
  desc "Increase performance and stability of a MySQL installation"
  homepage "https://raw.github.com/major/MySQLTuner-perl/master/mysqltuner.pl"
  url "https://github.com/major/MySQLTuner-perl/archive/1.8.3.tar.gz"
  sha256 "9b8b1dff03550f03c659d2b850cb287d784f0d79f193c1d8a969516cc44738cb"
  license "GPL-3.0-or-later"
  head "https://github.com/major/MySQLTuner-perl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6359b9361baf215e638d5fe0c721cfb017bc00e80f732270049c03cb0ceca28d"
    sha256 cellar: :any_skip_relocation, big_sur:       "c14b590e23a033c3389ec49b2bd7a6b21cb67ff9a7c48722f11f516653d3fb21"
    sha256 cellar: :any_skip_relocation, catalina:      "c14b590e23a033c3389ec49b2bd7a6b21cb67ff9a7c48722f11f516653d3fb21"
    sha256 cellar: :any_skip_relocation, mojave:        "c14b590e23a033c3389ec49b2bd7a6b21cb67ff9a7c48722f11f516653d3fb21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6359b9361baf215e638d5fe0c721cfb017bc00e80f732270049c03cb0ceca28d"
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
