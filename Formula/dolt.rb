class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.51.9.tar.gz"
  sha256 "994b8bdcb02c1bd39cfb584263e488dfd199a0e4cbe309f7a30029ef30a4e55f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "baf9d02ddd5552b2f6c2df18f7bd1684140e914842e22bcb0aaa356f967766b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33c4773fde7b740364537d0be033a54aa3891d8f644859b030553c55fb32cf89"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "441cfc49c84c37c7a38c55ad8d1eb9e265442dbda9e7067756eba671c6d0e0fd"
    sha256 cellar: :any_skip_relocation, ventura:        "e80f06e12498136fab3a2b57ce69a75f33212848c258a0d17165a52bdf39ed74"
    sha256 cellar: :any_skip_relocation, monterey:       "4f56e39bd363340de148c47665f7f7ab33ad081e21ae9b2151497186e6f2596f"
    sha256 cellar: :any_skip_relocation, big_sur:        "c624fcc525b27ddd96468dff54c83a4830ec4476ae71dae149d0b6adea824f81"
    sha256 cellar: :any_skip_relocation, catalina:       "d41aab2b341724da208fcdd3a6415495c0f27827c694a3b20bf3d9aa02d3d32c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5686b73eabc8c432bec450523e8acdf2999130662307cfda22df2e97e5383e41"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
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
