class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.34.9.tar.gz"
  sha256 "2f89788e5026fa09fd75174bf4b767b8bfcfafdca0141074298fcb1751fa97b5"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "906c80b3ef6ff049336be60bd00d32eaafef3fd612f2e0bb5f31f0003698799e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c4f286ce21ecf6364985b0e62d68b7a1e64bc9db9265f8dbed0da65d31056a3"
    sha256 cellar: :any_skip_relocation, monterey:       "c991858c378ff873badaaa7121a8c9d769c02972732774aaca01a4bac2d404f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "4282e1bd27cea9d8a9fcab7320397deac18464aec8d77a951f8e205ad59af9dc"
    sha256 cellar: :any_skip_relocation, catalina:       "6ee9ac15b3086e3d7f82b0e2ec3a4b14486aec010344c1eaeb47246f69d394d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e8dd8a2413e61f7c304e8c1637f2fa8b99f4ccfff9dc5c11e15f93bc717ab68"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
      system "go", "build", *std_go_args(output: bin/"git-dolt"), "./cmd/git-dolt"
      system "go", "build", *std_go_args(output: bin/"git-dolt-smudge"), "./cmd/git-dolt-smudge"
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
