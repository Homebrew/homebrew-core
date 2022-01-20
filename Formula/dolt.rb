class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.35.6.tar.gz"
  sha256 "ad66c00a09d744891c6e9b71e4489fcf6465dde983499140d04169fe0469f402"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79eb84390b44a7c1d1ea02f9396cb3df57254003d4fe992f030f38028e76f185"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ddc5a42215903a6c7b75961c26c75660591af7be1ed8d2157a5b7eacdb881925"
    sha256 cellar: :any_skip_relocation, monterey:       "c593d73d1d998b81a919a0255b30e830d10421752a4f6e4f2d199da2dcfb2218"
    sha256 cellar: :any_skip_relocation, big_sur:        "bfc642a6b8f86e35047b32639dee757999de884183cd756ac5266f1ba5bbabbb"
    sha256 cellar: :any_skip_relocation, catalina:       "749c41475b805cd93654f2ed6b45921cf3cc8062f31814e7e282fed1d8973ff8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b69e278fb06641a92f0726635189f16e4b6fb7762742fa72419841c1e6b0ca57"
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
