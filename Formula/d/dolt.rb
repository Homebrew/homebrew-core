class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.18.1.tar.gz"
  sha256 "55aaae262dc7931ba4f7f95596495fd76024813406cabf994d924ac87e5a7f44"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "70588f0367a07efc0bc6efc910b84e196ac6560a22e0f50babf2f594950cd026"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8fbb0b8fdefe15a24368825c97e076c2fae9a7ae1f0950618779da88a2b16bab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1872c2a75fb7a878d14b1df867a943c4c74d0c90d43810095a60551db2925b9e"
    sha256 cellar: :any_skip_relocation, sonoma:         "f05b42f7e5f312155f7538e04308043f489e9634471987bcae1b2a77f5501fc0"
    sha256 cellar: :any_skip_relocation, ventura:        "45baea3c0948056adac0fed86360d220bbcf86bc32c15a1949d77fb15453b84d"
    sha256 cellar: :any_skip_relocation, monterey:       "4002d61ef98e831b9041bb9ad5c21bb8c261bfb0fb1f2ea02e322dcc7ccf14f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "201fd2f84129ff47c2e3f502844b42af91e94347943fab10c44b8025e76e869e"
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
