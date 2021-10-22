class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.32.0.tar.gz"
  sha256 "03dbee51697ade6c6d5fdedb9929c5098235a8e4ff4466c8cac952f3070b402c"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "60de993c60d6ba7fe3b580e24612ecbf552cdb96f0352c91b9a966074bb56878"
    sha256 cellar: :any_skip_relocation, big_sur:       "43bd13bbfd9e36f3e8af04c600aa4b9c115271fb334b91a25263e8edd83cf42e"
    sha256 cellar: :any_skip_relocation, catalina:      "2497c4dc25ac2c506e2e1c6c24b63cffd471e38abbdfda0e96a0da14656f699d"
    sha256 cellar: :any_skip_relocation, mojave:        "ac129c8c36898d9c194fc690e3f8ded3eecfcf5d7c7febd28519e24a83cc3135"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf0be253d2070486362eb21be49b26073b3ed16a4fc66d7c12a5cd43b8486c69"
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
