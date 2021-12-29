class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.35.0.tar.gz"
  sha256 "796efbfcc9805a368eed547dd854b950d6b9753e13614999b0a69814d9753e1b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "deee6286b583d12ecda7dc3e08ba97c928399d8403412f276a4bba193c1f0831"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4fc232ca461ad7126e2b3f84869414d88b713524aa00e8a0418f42ca6a5cf3a6"
    sha256 cellar: :any_skip_relocation, monterey:       "5333c6ff1b3b4555e7ca320ca432e79f9c35247042c9bd0038f91385497960e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c69cb90477ac8c021b0ee031334d2a20e252539355fa03cf89dcd94b431baae"
    sha256 cellar: :any_skip_relocation, catalina:       "ab9746da49c7b73f01523a3ed72598ea29bbbb2b2851505a9008109d2ebad4c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a21c825da0b447edf8dd2dae6aa8da6754e8736f83f9a6b6e90fc7739c1bed36"
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
