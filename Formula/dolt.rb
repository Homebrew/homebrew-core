class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.34.1.tar.gz"
  sha256 "88c2d143431b8801b677d201456cc1096a12a2920c554ec994a30cab773cb005"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40be8875aa2ceab70507253e8bc7f5e8a704a7e042be4a57c2753f5898642736"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73ac1aa0aef2ffacd085e42cc641fa269a66ba61bcb19d129fc624a2ba2e09dd"
    sha256 cellar: :any_skip_relocation, monterey:       "45ccb39090135f307914042456f9528d3443fd1aad4aa2688565cdd00e6da8f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "f82e49412bd7857b8b963494d12660e21e5466df88ec145344c13938f6ab1ee4"
    sha256 cellar: :any_skip_relocation, catalina:       "32863c0b7d5abd5ddc49eb7210bb83ccc86a953a2ca03b94b3a273f084ac64c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a29117cd2a8a1d9b39560579af8be06cdf02998ba86d7d92d67c68acbd783fd9"
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
