class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.36.0.tar.gz"
  sha256 "0b8630b09e28dc478fb2545c6fbe52e679b9a2e5dbe569982c9649655ab969c3"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a75d4db80160423bdedce1aff7cad42e92b1e977caf50e2dffd2da798ad2505"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dcb5b4c336b73a2d5afd5999ec46b2f47644b5af9945cae2cf12e942ba4240db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2206a8386cff28f6cb2e0f37c8656eff4a75b2adaa86fb7eb68f1dc5b6000b1f"
    sha256 cellar: :any_skip_relocation, ventura:        "ca4758a1f2b71d77ff363acea9c6674fbbdbb2cc0e4b64ca5ff3eb31ba0ba11f"
    sha256 cellar: :any_skip_relocation, monterey:       "134491db74e4fecb5f83e9a7fd39003f183c8e54311d208c704ba039f128e6a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2bedc1f205405960d6f5a31a5430216527f6312ba8125f89b0e1920fc281ccc"
    sha256 cellar: :any_skip_relocation, catalina:       "72ca9a23d0b77b20b57a00b4fe06abdc2e7bc1def7c355a411838a9d5b3d560f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "737ff10826b6c948a4bf5cc8efdae0388c5fa7bd6f86e0f1121495847fc7c18d"
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
