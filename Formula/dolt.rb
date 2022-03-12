class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.37.5.tar.gz"
  sha256 "adf1d9741c2ead759ab8905f846ebf45b03634354f349b8f2f1447e9c2b06c67"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9bc7c6e1bc9a6ca3751324c9d33f693078a78f750cff7cdcac03a9b9b233660"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "982cd588c61e091a12f8cc26cc3fc2f49811d562559e3cdacff5cea7dbcc4921"
    sha256 cellar: :any_skip_relocation, monterey:       "d5efb5a746686174935415fa3de9084a5257e31b8df139975253818bb9bd8565"
    sha256 cellar: :any_skip_relocation, big_sur:        "a914dc237cf5215c86e4fb5a6c931bd6bd5bf77f98b7bf9cd2fc4abd1fb07105"
    sha256 cellar: :any_skip_relocation, catalina:       "967ca25c156a62e38f451bcb219e5b82be8f048ee6de22fab01ca1ff08393033"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ea42a3cfcfd38194d9863a797ca7d429ecebc417c8069d4214d160df4f8f93f"
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
