class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.22.1.tar.gz"
  sha256 "c54927112eeabb2119fd5245e3da083e212ea009566b1d2d12ca6084814f469c"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/liquidata-inc/dolt/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "9022fc0dfc01f0ef0a429cdeda9099df2617385517acf74425cba6a93c934a9d" => :big_sur
    sha256 "80996f00c2ab5969505af14f35aaed07b5cd5cab357aca3ad08e0ba3c2cb9e1a" => :catalina
    sha256 "e743819e71d685b65f73d86958ab09b26727a00216eaf6adf79da43c1961b7a2" => :mojave
    sha256 "0e70d4f0b7655e6361a0f0f1f387e20fa1e92f4b4f2b8664cbf83648f106c7c3" => :high_sierra
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
