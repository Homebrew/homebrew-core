class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.22.13.tar.gz"
  sha256 "4b455a8284cb80b5c31311901500a83c263cb6bb27b1bf8919c4f532bbc395bb"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "354869788cd1fdb69f57cac42d8303cd39f1ce564cc114c910f7e5fd066d74e2"
    sha256 cellar: :any_skip_relocation, big_sur:       "50280cba7808e47806cff56a141f7222ba1e852120baf55fff7bbd8f91768fbf"
    sha256 cellar: :any_skip_relocation, catalina:      "f5eebb9fbb679f0e6dd30d37dee2c4ec71d307daf0f64cbfab5d67e1d960adff"
    sha256 cellar: :any_skip_relocation, mojave:        "751b02d3e61dc8963d23c743718de7cf9480039916664b735db2cf7422ad6833"
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
