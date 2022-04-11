class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.38.0.tar.gz"
  sha256 "af437752522b14fda84d096c7980e27d9baa6b55aae6cdec715f801de979415b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c564669ce4cff082bb59baf47ab1b7dd0008577b7e735a051e3d5bb7ca7d50dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f789d725246a857ad437180e9f68d1739ceaa82678f22c8f629c481b1045f44"
    sha256 cellar: :any_skip_relocation, monterey:       "b97eec5699597bd0d69e51b4dc15338a40fb5691f9083291f4a0a38a89ddb5b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1764df834803b7a287f7b1d41565efdedbd2c98a509390a06a1ced10c43871a"
    sha256 cellar: :any_skip_relocation, catalina:       "265fbbf5c2d0a3d5403780a24a52e07ff58a531878381716916b744af71e9250"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7dddb0b1f1c84b87f2ddd71749fc147af22fb22d7b9d909f4b6704bd44475072"
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
