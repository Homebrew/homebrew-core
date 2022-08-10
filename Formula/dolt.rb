class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.40.24.tar.gz"
  sha256 "aab42ad2b5ab92ff2fc5fd2d140e34be93cc011218239ab203b04cb1d025d3b6"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3441948b624bd4ac255c4038ff7791c80497d5cb1ce16c6817ba9c163c7399d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "091f5a8fa86f9892e7239c6422eb86a1eb749b4347a74a16c23dcc04253f83d9"
    sha256 cellar: :any_skip_relocation, monterey:       "7345e32baab24c8e3286eea63585b27569a59e0e1362b4aff9382c0e7b73f188"
    sha256 cellar: :any_skip_relocation, big_sur:        "a596e61844ae12724337a323758de2fbb0da4e952cb0075bf7b320cd602a20a5"
    sha256 cellar: :any_skip_relocation, catalina:       "85245a9da3f63de99bf0293e7e01e634a342efe23bbcb1ad35676cfa4549fc62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27f95008e30989b7693b9363833119088cf62b498928dc2b9b7c8463825a7ccf"
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
