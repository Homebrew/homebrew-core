class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.24.4.tar.gz"
  sha256 "da81c35375579cb9bbbdb8c9092510e19c52ae91065f8dfa895f8c389d9f3be2"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9582b778380b8b672b0ddc1551ed4044ed796369729affd05e5f7bf6d7eb9e36"
    sha256 cellar: :any_skip_relocation, big_sur:       "26e30182fd752376fbeaa17a0c3cd9c076b17c691a0a4c9038e014aa77723709"
    sha256 cellar: :any_skip_relocation, catalina:      "dd04c00296e438d27cd1cad3a5cfdfba97fe3f5dd5c90a3d01d5651a47e7c266"
    sha256 cellar: :any_skip_relocation, mojave:        "82fb6b2c0cb0ea1a5cf7d44138760ab0093ce23827d0bbe817f15dc86ca691c1"
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
