class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.26.5.tar.gz"
  sha256 "5795a3c25f7eb4cc46ed8907ca570bc32343bacf9dedd66a2eecd0ef8be48296"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d9b7b2be63ab81cb7db2846132888d22550c36f327d0b7c20f3c6e56445af4c2"
    sha256 cellar: :any_skip_relocation, big_sur:       "39cef46e42ee3dae353ff87dce8ac1fac26b6499f28a591e284ee4b37a7b47e4"
    sha256 cellar: :any_skip_relocation, catalina:      "e6f6b3f0395b2b2f5aff9a254331b3c45d88d2c7de7e699dac4cf5acf8e46b44"
    sha256 cellar: :any_skip_relocation, mojave:        "3cf0356e376efa23cc97d440f4251330b6411af66aaca759997bce732df0d40d"
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
