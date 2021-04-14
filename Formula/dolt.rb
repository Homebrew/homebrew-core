class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.26.0.tar.gz"
  sha256 "2239ceb95403f0c4a0efb63d423636e19ee8c0f7f4ec0d1f5be8e3aeac995292"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0f9336512d7093c14ebcb939f160f5c821caf5aab563560234d1336f1b671a06"
    sha256 cellar: :any_skip_relocation, big_sur:       "93e271ca938cc8ddfd9f39dd8d9fbce2c56677b18f8398143b64f7ca0abab274"
    sha256 cellar: :any_skip_relocation, catalina:      "b7926054b9e413e8f8ed95fe63344ff01a2d143bc583730ba78422b3c05d6d9d"
    sha256 cellar: :any_skip_relocation, mojave:        "68594ac9563dec7077e770f1ffb0f58cd21da3fe4d9f1295c651477c77f5cb79"
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
