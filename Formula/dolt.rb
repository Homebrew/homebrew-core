class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.26.10.tar.gz"
  sha256 "0e5311fb51b257965cc933dd803144112113f0e4a8c4d145f24fd8bb143acdb7"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6e9b200c016b1decf5b1bbd70ebc2f8ea3f2c336a843ca5c35b104cfe5ceed3e"
    sha256 cellar: :any_skip_relocation, big_sur:       "fe2dcc225fbac77649ab2ee55a39905e8fe9190cb53b6aec1db9d0fd7c40f0d8"
    sha256 cellar: :any_skip_relocation, catalina:      "939a866cd68e27c719ae2258eb261a66ab9536961bf05016d2044c6753fc20b3"
    sha256 cellar: :any_skip_relocation, mojave:        "5dc8b675f0b88bd5a620f7041167467a08c7c2b8d1632f540b35ca5a81291517"
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
