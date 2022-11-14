class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.50.17.tar.gz"
  sha256 "d9307c07cc7ed517859e1a7531ad8a6d976c29c6954d5099e1ee18effc610dfe"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80a4e2cc54698d4d0bb3a6f19c29623a2e1f9816c18e787de075b4074274a58d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7c07ffca70b9f12863d332ad97c1e7eb8ae9fc665d814c9d78859fecc21b28e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "058116cedb25217eb10c901021cb15a66162591c93375074185a6bd4d9b4945c"
    sha256 cellar: :any_skip_relocation, monterey:       "bb1f97f302d308b51f67fe3aaaad34438b5e704273cb8a79de86d10843f97118"
    sha256 cellar: :any_skip_relocation, big_sur:        "7892ca93eaa298a68ee5b878146a5e2583cb6bb476dc3f94c35409fc94d7b701"
    sha256 cellar: :any_skip_relocation, catalina:       "1ec62855b3416930657cb93967e1a00afc3a95b71298be0dbe58d1dbd02df007"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94dcb649c6a663ad76ab75371acc6cd099b2512b29a8eb2a3940c49e6a668dd4"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
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
