class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/liquidata-inc/dolt/archive/v0.18.3.tar.gz"
  sha256 "2740903fd29458dba866a9bc2716843267d378ace589aaf58f7353ef703e091a"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/liquidata-inc/dolt/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c03cc532d5045fa090cb4e0f141883685de3765bf1d221e400c750b3ae89e328" => :catalina
    sha256 "35472e6406e5035cd082a200aae2853488cc68c34f0e897dfef4420c444052b6" => :mojave
    sha256 "cc789ed17093d7fade947321f2eb61c3fbefe8caf62518b0653b93537e6cfdb4" => :high_sierra
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
