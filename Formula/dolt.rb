class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/liquidata-inc/dolt/archive/v0.18.2.tar.gz"
  sha256 "a7e40781f1b7000b4c1dee3ef4cff9004b13f7a3dcb8dd2725ac6cd470020823"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "3849972071e1224c9f3997ad74c0f7e8e2c0f34e28db7d69d0a3d173401a418a" => :catalina
    sha256 "07fbecca6f33b8c6ea71779cfc6a609cbe7890e0663be7d1eb61cf4e72e445a5" => :mojave
    sha256 "59bddbc645a596ffc60c7e25838430d9f986c1a932cfc8cc92cd0e0459e2b1b5" => :high_sierra
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
