class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.52.12.tar.gz"
  sha256 "419b54fbb25c9fdc10925816210f3fd5caec1f7c2d1d1174dfffdc930592f034"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35ae0fa5dfb7b59925284d1824cb2dfac3755aaf7de7182bfbee7d9223448c13"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5a1ce854572da22a2a0fb985dbb4f0edf653ab3f22c0ca786118f58f52639d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a997de7c2b5c3bc7d70b0832e8da95020e3a261fb2869a9131b87c13e9aca07"
    sha256 cellar: :any_skip_relocation, ventura:        "4c8b0104eda4bc319fdd327d5a3cd42d386fae782ea040a023713c13b4b81bc4"
    sha256 cellar: :any_skip_relocation, monterey:       "5ec5bb797f358e36b52b3261b6f9c1f3728fa4ef00cc2d61d200ef73ef12c3a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "b46bd157647eea60b257366b4629d8099d8cbd7f65cbb51de4106f6d66bf5692"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "858d67cba210ae8c8d98d613a25f1052e1391c8106a08c829562cd4617b8f263"
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
