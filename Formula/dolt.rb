class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.40.9.tar.gz"
  sha256 "d58a80a0ad7336689c2ebbd6a7b28359bec2a04b8fe5205a9533c7b1ef9daed2"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93895103f420568c327078543d612aeb5a97555bdd4323a6797817a1189295b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "deea4f2d915830218ff6187cb97835ae0f6a31b8a8517f9284ba22e5a400fb05"
    sha256 cellar: :any_skip_relocation, monterey:       "da2b9971465f996529affe6eb097f6bd3f8aa4719acdec7feefe1fcb3d6e667d"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e501390bfc05c1d3cfc70841e469ce0752188efbd51a1234a4792d958e4d482"
    sha256 cellar: :any_skip_relocation, catalina:       "594992908daadd079783f7b6f0345efb9373793e9e012c73204d0128db805955"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6e9aa3f141c7545d3a51bab24751575a743fc60a952e015073206862172eb78"
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
