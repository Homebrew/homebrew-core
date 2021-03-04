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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0412d950240ad73687f911e0a23d9ecbf6f0405ac772934ad4ed7b79a086e1ae"
    sha256 cellar: :any_skip_relocation, big_sur:       "e4d3e5666d2dc58c2fa7666d5e63a407258fe3a5c48c0a7c104ebf68f444f73f"
    sha256 cellar: :any_skip_relocation, catalina:      "33fe7851e7a615acc0a0c9256ee433e6dd594efdf2f8b9748c716ca72f625fc4"
    sha256 cellar: :any_skip_relocation, mojave:        "f4475eaff6695074c2c1f6f6e111ef156e860f0e6cd05c2d4384fd8fe405f9a1"
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
