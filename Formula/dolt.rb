class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.52.3.tar.gz"
  sha256 "1cd3ec062f627dc4924aafacd33fe04011f51e25444217a88a3892c43f0aa7c6"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3b8c4c8941a4b1cd264fdd8fa0b82766a807d6b71e68a701a2baacc55069de1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a8fbedea8ff6a83ea858c4015328ce21cc01da5c2594641a164b724c41a97cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9b8649ebffbcc6cb0f0b5cbf472655fe64e3eba9cd8fd2637cfd20ad39f8cab"
    sha256 cellar: :any_skip_relocation, ventura:        "00b998f47b9619a7c8fc7e75e833b2a5526026d33187aa3cc109d84194678ec5"
    sha256 cellar: :any_skip_relocation, monterey:       "60d64144c7fa3029b1c672084bedef6e32db887303b5c46f564ef07e0a8ea6ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "76c7280af794d7f27a50d4f1b5af18c53282d11e41348219b9d5c33e8ab34cdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d098bac3c4889f0d6140028d6478ec0008c56efc69dc5c68688ed5593ade98c7"
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
