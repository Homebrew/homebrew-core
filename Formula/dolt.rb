class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v1.3.0.tar.gz"
  sha256 "db26812fe1e93df62dc02eefe1083dc94ce8ace368cba4412c8c51079e707e7f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aaaaf1831a2918e90d1a63b3865208c96162192d9d869ce460c16b5b39ef37ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aaaaf1831a2918e90d1a63b3865208c96162192d9d869ce460c16b5b39ef37ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aaaaf1831a2918e90d1a63b3865208c96162192d9d869ce460c16b5b39ef37ff"
    sha256 cellar: :any_skip_relocation, ventura:        "ba67ae237cf30f35287484104b3870d21201cbd706deadbae43b36ac82f7be5f"
    sha256 cellar: :any_skip_relocation, monterey:       "ba67ae237cf30f35287484104b3870d21201cbd706deadbae43b36ac82f7be5f"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba67ae237cf30f35287484104b3870d21201cbd706deadbae43b36ac82f7be5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b966ed2fec7f118ed9a1d22c30c890d4ea05d2456fa289c26c140c8cf9956d9d"
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
