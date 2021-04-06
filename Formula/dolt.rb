class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.25.1.tar.gz"
  sha256 "2998b1d427093a19dea9b018c37c370f2cfbb4999546de277b3010f57fd32527"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fe473d41a348b6cb78bd44205575b7171d63256443a2a50e00b6344db8c89578"
    sha256 cellar: :any_skip_relocation, big_sur:       "488e23130823ab57bf95fbe3a1c53ff8dec85dacd4689db6ca788cc78f8174d9"
    sha256 cellar: :any_skip_relocation, catalina:      "43e33caeda6bd1deacfaad6388892d8f02d0811cec19aa1ad1d9e24abec1ef22"
    sha256 cellar: :any_skip_relocation, mojave:        "3a57af08ae456207325ee0617ae7cf1cd62d26a6236351c7f4029f4e41a782c2"
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
