class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.75.4.tar.gz"
  sha256 "fcf954d2552639aa09276c4786fb15324d641758ace7f1567b3c0b31269c9a85"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53f3eb1ec3ffc05c57534759a01a41fcad5ca9361fd2107ab42eb4b3cd22d462"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53f3eb1ec3ffc05c57534759a01a41fcad5ca9361fd2107ab42eb4b3cd22d462"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53f3eb1ec3ffc05c57534759a01a41fcad5ca9361fd2107ab42eb4b3cd22d462"
    sha256 cellar: :any_skip_relocation, ventura:        "626d309b90a97cdd1ed78c975b766bf3bc3e71318929502db2c24f93c12cd001"
    sha256 cellar: :any_skip_relocation, monterey:       "626d309b90a97cdd1ed78c975b766bf3bc3e71318929502db2c24f93c12cd001"
    sha256 cellar: :any_skip_relocation, big_sur:        "626d309b90a97cdd1ed78c975b766bf3bc3e71318929502db2c24f93c12cd001"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70792dbfc0fa2365088fbc0b69c9f4f58e3b15bb807d7f5241796cfa7da3531a"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
    end
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin/"dolt", "init", "--name", "test", "--email", "test"
      system bin/"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}/dolt sql -q 'show tables'")
    end
  end
end
