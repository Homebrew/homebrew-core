class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.35.tar.gz"
  sha256 "fe5b2278d7b5b22058d139ec8961a09197d8fd26d7432d263a583fa9c1599d6d"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a943392e31f1f24c669fb86ebdb7e5f01a3a1d0871226d629ced2daca8f8a32a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fbcc75976046775c94bb9d6debad4860201437f47b5d4ba1ca976c008f802307"
    sha256 cellar: :any_skip_relocation, monterey:       "6213ae4af0c276e446d0ec838042601f3c7ebd90a365943d21b0ae3801180521"
    sha256 cellar: :any_skip_relocation, big_sur:        "1407f804911461df93e03ac52dfbbe13bf2812b4d3199d94a640fe261aa70f8f"
    sha256 cellar: :any_skip_relocation, catalina:       "3c8dd7bfc83456355a3f2ecce7e69837bf859dca379e2870fd73b3bbed51cc57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee0e6a370121bfaaf9b9c82903cfa664496cc7600e7899552631f7348f3c47a4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-o", bin/"lazygit",
      "-ldflags", "-X main.version=#{version} -X main.buildSource=homebrew"
  end

  # lazygit is a terminal GUI, but it can be run in 'client mode' for example to write to git's todo file
  test do
    (testpath/"git-rebase-todo").write ""
    ENV["LAZYGIT_DAEMON_KIND"] = "INTERACTIVE_REBASE"
    ENV["LAZYGIT_REBASE_TODO"] = "foo"
    system "#{bin}/lazygit", "git-rebase-todo"
    assert_match "foo", (testpath/"git-rebase-todo").read
  end
end
