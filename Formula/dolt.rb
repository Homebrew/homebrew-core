class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.35.4.tar.gz"
  sha256 "0582eef35de77460c12edf44dca11782b7801e381dadfdf3665489ae6dcbab22"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4f304c436d9aa7262052d08d7647005bf4065f01ac5dfd41ba720b06e8781e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc74e0befbd7911f08ab23a8f1560e6dd0aa895d682a0b629606b30aa4f3421b"
    sha256 cellar: :any_skip_relocation, monterey:       "fcaed630956440b434d660353c7d435d060595664a73c4477370cbd2668ba573"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d3d396b17443d42ac65e2f8fc7fec82569b7cb2186412aff01bc2ccd7833599"
    sha256 cellar: :any_skip_relocation, catalina:       "79658d89f2c3ed9234311b9cd0a5a113761afc1686267071cd76120841f033ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb311c9d1cf2bee71e90157904b097c2a36e4f13761aa4825f652d0f438f3886"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
      system "go", "build", *std_go_args(output: bin/"git-dolt"), "./cmd/git-dolt"
      system "go", "build", *std_go_args(output: bin/"git-dolt-smudge"), "./cmd/git-dolt-smudge"
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
