class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.28.0.tar.gz"
  sha256 "988fba20f94c639b75e9961179cb5b0444544a89cdd3621ebb4bd3f2ff89419b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "17871576622e89dba09919f257300b3a58b99acb05dd5e3a1e343673bc62ac9f"
    sha256 cellar: :any_skip_relocation, big_sur:       "5770f27d60c14a40083b5bba1acc4997063008e121f36789a4067aca38627821"
    sha256 cellar: :any_skip_relocation, catalina:      "0edcbc9163d281453b277a96b14f1b25abb9be35419af66b780b6dad1fe1aaac"
    sha256 cellar: :any_skip_relocation, mojave:        "ca82d698d400593e24d0599e21f67b52d1cf49c8279a7247fe3f45c82c3ebde1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27c3cbee3ae8d25ef2c9f8bd901bc7e88b877872923f4189f64129cf5cbf78f8"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
      system "go", "build", *std_go_args, "-o", bin/"git-dolt", "./cmd/git-dolt"
      system "go", "build", *std_go_args, "-o", bin/"git-dolt-smudge", "./cmd/git-dolt-smudge"
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
