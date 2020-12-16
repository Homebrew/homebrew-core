class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.22.6.tar.gz"
  sha256 "18c766b0de8502d52bc39a67274718cf31f56f9e4f8b8b000d2176c0f7129c59"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "13add390dd4f3d8979920352353fed43247910684e2b7c15e2d60e29788ab721" => :big_sur
    sha256 "43fc0267187e0f68f684ce78991468ba2c3960f9e6a8cb00c08acf5ad0ce58e3" => :catalina
    sha256 "2e725d4419572d774cdf9b4953e358cdf0809111658a8f5a029ba12e02dfa4c6" => :mojave
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
