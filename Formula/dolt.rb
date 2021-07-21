class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.27.0.tar.gz"
  sha256 "01827498e7d6e50dafc574284f2f70ba034e53560e3c25339a95b312ecbe5582"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "84c1ac36ad11af9840ccc40cbac75947d609e9d874b20f170c5795e165b77e18"
    sha256 cellar: :any_skip_relocation, big_sur:       "1f0cf09d5d668b55b2904c160b6f5cbe67fe061d576875444a97c49a85ae06e0"
    sha256 cellar: :any_skip_relocation, catalina:      "22ed6b157100b83069557d04c9787dfcb513059c059288f0e1e26a4f458fc0e0"
    sha256 cellar: :any_skip_relocation, mojave:        "a4ba9b6fdb4f48f196a714cb5a3733804fe3c0ffee57413b6b9d11bbb023b227"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21a6ee61ae62054238f0e465d090dc8eb0a47c6e80eb03355eec6501362075fa"
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
