class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/liquidata-inc/dolt/archive/v0.18.0.tar.gz"
  sha256 "326426242a4e6dc7ec372c701e2e90f506f85dc33fa876ee5c4337b2f851d08a"

  bottle do
    cellar :any_skip_relocation
    sha256 "dd9b3774908ede4653cfa2d08127158856b96c7058414ddde488d78e304ab250" => :catalina
    sha256 "0571eb669cafa0f0e872801080e6a6ea8f8a9c76946e05f21faf37e6e35501cd" => :mojave
    sha256 "523e18477982490e98820a30380167752dab63c2a2e7bbfe6b5a1f97d2a6a4ed" => :high_sierra
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
