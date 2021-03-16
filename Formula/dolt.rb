class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.24.1.tar.gz"
  sha256 "229660073eca1b141bd0daf12dde23d78f204539c6f75c424cc0fd915f0fa781"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a8d10767c6dd5b0ee09ad83fced22d078d4fadec8c31655b4d9a295fd9c77bdb"
    sha256 cellar: :any_skip_relocation, big_sur:       "002f2ae9e834468a46b062b315764d679d00a2cb6c6bf075a528b1c93b6e1f19"
    sha256 cellar: :any_skip_relocation, catalina:      "6adef5f64b4428c768a5299718ec2a32d97dfc363216ac4aaf2e3c45da2ca783"
    sha256 cellar: :any_skip_relocation, mojave:        "81df0f4ba77a87e7dd5b6f07040866b2fdf3dfb7299e189a8fe54f0f8dd9a2df"
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
