class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.35.7.tar.gz"
  sha256 "de504ec39e4c1c68c7d2f48dcf2c20e21ec8cf450fab58d5fa415c54b8a1a430"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c06b3d587306aa1dbe9b1eebc10928fd4c630378dc1fb15805e0f7574078d44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8bd40c1fcd11556d6cc4f5b391710c6e7fb09ac4d944fc2ea26f56964b4c989b"
    sha256 cellar: :any_skip_relocation, monterey:       "c5a09a08ee31d84b80651334de3fa23cb5c94b644b15e4dba38101cf8c9add79"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ebf8a04225b0ba0a3189b2d7dd1c062079f1751cee274eef7bdb49868699b36"
    sha256 cellar: :any_skip_relocation, catalina:       "e2252a20284739af6ee3687ea15d23656a9c9c659933326b32372237175accfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aecbf0b1dd461a515ac4a1cbcce1d0efbdd37b93d93d69f0d675e4091083f4cc"
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
