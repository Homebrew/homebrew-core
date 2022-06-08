class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.40.6.tar.gz"
  sha256 "d6e4b99526f3f1d4b4068fe1a6e7a0e5e09b48b5a7c025bf128683414af1a757"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85bbf295aa38f1ba89122df73795d864363645e98a9ba1ef76787509320f6284"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1a0a4bbc7dd921c7f7565b8b3f76827b9a0d4c0b6fc3ad3296d45c79e65de85"
    sha256 cellar: :any_skip_relocation, monterey:       "4d6c1215979eee57f0c11a6ea51ef27ad171fc91064c19187c7d80cb379543f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "618a45e788333d337d70938003c30e7f20d9fc100d18406b45a31c91db57dc6b"
    sha256 cellar: :any_skip_relocation, catalina:       "1d24a4927da30a245abb981cade2747029309eba72007e851a667288428b40b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c64aea7114a7b7c3a36d2cc8a271b29d1eed7968134b4cb62f57955b29e4ec4c"
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
