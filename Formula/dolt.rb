class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.27.2.tar.gz"
  sha256 "6792eb54ae87f3984551dfe2c3a15fce59e3a7884b730cf0daa9011c0f043372"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fb47e5ae7b94ff4d30ffa73c3247a3ff268666b895ef210203122a08a998af9f"
    sha256 cellar: :any_skip_relocation, big_sur:       "e9369047ba9fbaed2bf6a6e28ce2058c8b516eda559e4ef204df039df78b470d"
    sha256 cellar: :any_skip_relocation, catalina:      "583e8274cdd71dbe9ca4781a6242e3ba4901c08dec66f087604e1df087e7ce64"
    sha256 cellar: :any_skip_relocation, mojave:        "513b303c3e1ed2f64684feb34e39bd1b3d1fbd2937e05b39476e6b9f25afa2d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea848cd76ccb1c10537b90ffa6592ebd35a68df42052832de8d0977b2c9321b4"
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
