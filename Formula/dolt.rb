class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.36.1.tar.gz"
  sha256 "22477482f3c554e702b970dfebd37dce9be390ebf7ebdcb85d3e9dbf206098ee"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efac4401349d36db29fcc4cd01d720ca485f8929779c4fcefefc23d8cae09270"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6681cc73d91f951c3861763c17fc96501b0e1de3996088f7db097d716c1899d"
    sha256 cellar: :any_skip_relocation, monterey:       "e12aa68241609b3b4e8413ffcbdfd83270b66f60b98abd7a6d4d6df7f11dd029"
    sha256 cellar: :any_skip_relocation, big_sur:        "a2c08ba3fd764ed0c3320869f2562ba8f963d82d38fdcf83c987e43e3658fbb4"
    sha256 cellar: :any_skip_relocation, catalina:       "5aae5a3814b8a6d064f6c8b11a104fda9b322c7ffc39ea57ddb7b7d0f4a5236e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dedc2e6bee111a656ed5b095d8aa8c7c34129a4342ce205d5b9e057c49ee13fc"
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
