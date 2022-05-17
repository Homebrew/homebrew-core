class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.40.1.tar.gz"
  sha256 "1d17c9bd9857be3cf6a17210f90724b8b0caf80233e170b621b35f1556c58ef9"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c72dd996a265a6e547f347b6e19ef29641ab857436b7bc1e8ece99da27c90a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81d36235979b10bb6b417c539501962c5ed4141f6da3ca3cf31349037c8486fd"
    sha256 cellar: :any_skip_relocation, monterey:       "a276ee7fd86ad3c3bc3650dcabdb990aaa348b8e8ba2c517de53f17271eab93d"
    sha256 cellar: :any_skip_relocation, big_sur:        "90a5a69817cf4516f2965039563710504d4c81a359ea70e445fdc956dede55c0"
    sha256 cellar: :any_skip_relocation, catalina:       "467597eb94fa1d4af7c2f7ad27dcc9ed9fe8c4d8d408b64a1b65cf2ee36092fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5b07e5b588721af144c0f6750b96b5a7136f05b0685f53bf14a7ca4c910fd04"
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
