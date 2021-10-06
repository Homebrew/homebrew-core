class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.30.2.tar.gz"
  sha256 "db123fd251131743078be2565ec503a92158751108d3cc18007bd392d35a37ad"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e20992dd059456a8e3de87c488421b18b1b665ffc514f089263de053c442f553"
    sha256 cellar: :any_skip_relocation, big_sur:       "6c5c95e7dbeab91ade5fec443500bd5a667a56d0488e7c06e2b73e2c69ef9bb7"
    sha256 cellar: :any_skip_relocation, catalina:      "4fa42548615b15f6bd690c3f65377282c2f9ea7bdf92823378331cd18ce50413"
    sha256 cellar: :any_skip_relocation, mojave:        "8327de9df9d28e7baeab07306ae1430df1359016f6c763043bc7ce5361a3c73f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59f415482e3b628170c50cb68afdaa6b408f9d12f3b5f1591debf7f5b929db39"
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
