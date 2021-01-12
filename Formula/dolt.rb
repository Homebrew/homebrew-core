class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.22.10.tar.gz"
  sha256 "34ce0d82676976a01a7eac80305b9ed9c3e1556a32f9cbb5ecdf9415a286828f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "1659a51eb43e33fc752349e15a28b5fb252c89b0124edf28b5318a398f84d614" => :big_sur
    sha256 "2f80125305fca5d34c7d96459a64c623b9ef9046b270c3dca45606b789246f93" => :arm64_big_sur
    sha256 "50d273b2159a5522ab91afa9d1eb59370a3c368a3755d893f31ab77edf495137" => :catalina
    sha256 "366255bad8f9d9e08b10459046ceb8aadb47839b930de707a184d63ae1b1043e" => :mojave
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
