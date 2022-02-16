class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.37.0.tar.gz"
  sha256 "6bac41db4fa46314a95b62a71b3a538cc0f04085c1502b6d87e9f8c6d5495d0c"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64afa31db700f3a85f4ac6025cfb91e0b724d4a6b0a950ef60c997edfa480b81"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa5d76550681bb8e252aaec5b4cc94b0e47049e4f125a97c4840784a2e050ecb"
    sha256 cellar: :any_skip_relocation, monterey:       "f742460a3e7a136b258f25b896b5284e3b3feea568586de37e507779a42bf22e"
    sha256 cellar: :any_skip_relocation, big_sur:        "886f07a217b82a73a5e72488a063d81cc9ece0f96ad7753afa6d5dae03092577"
    sha256 cellar: :any_skip_relocation, catalina:       "5c8af16dbd0b8bbb8460c33342dec71674358de5e5b1bbd3a581113f19c99662"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4acec655bf3656c728f6217cbaf553554a8e12cd0de09e255e932544d7151642"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
      system "go", "build", *std_go_args(output: bin/"git-dolt"), "./cmd/git-dolt"
      system "go", "build", *std_go_args(output: bin/"git-dolt-smudge"), "./cmd/git-dolt-smudge"
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
