class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.41.3.tar.gz"
  sha256 "875625691a494250b837fa644c6d998fb5f3bf7e81ad931158697cd9143e344f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e4d9a4c40de2055a1b30fe63ad2402063b6dcce4ab1d803010e1e00a43f75b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8046d752c3fd37b18f0cb0b2db35a804ca02c71e9f2936415d6c629bea9074a7"
    sha256 cellar: :any_skip_relocation, monterey:       "e7f652ad9ac30c29259bf5c49e3af725435e415dc95aa5be1c885d769647a1b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "79e8000690bf8d868dd436ff7310c0945202dc6b36a5391425096668d53241f5"
    sha256 cellar: :any_skip_relocation, catalina:       "da3639aa6f1e5a76f73ab85b3659e0c6cd1c623dbc8bd96b5905591f3d6d1811"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3840d5cef054476e22a17265c391e6f33c7a4a3267545a0f1e1d17e54a331909"
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
