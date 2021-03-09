class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.23.9.tar.gz"
  sha256 "0ed99546aed038e129c3daddf868344908334e99385ffbf1d20d057405fd4176"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d2c79473c5f05c45e63c88ff5c1fbd116d5a9fe4b4cba551071e91e2f332f858"
    sha256 cellar: :any_skip_relocation, big_sur:       "e9271d935e53cee3fd0f96297c43c697c778b34050c1644e5ea6262b3e11d9ba"
    sha256 cellar: :any_skip_relocation, catalina:      "1c307cee09b081c13df5ea672b454f3ee9ed35f4fc4e3371102a538f6cfae8d0"
    sha256 cellar: :any_skip_relocation, mojave:        "971d9fe1d958f2734b0c1842705c9b6b0f2d92b6d8d6190b63f6776fc5ef1bcc"
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
