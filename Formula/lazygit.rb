class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.35.tar.gz"
  sha256 "fe5b2278d7b5b22058d139ec8961a09197d8fd26d7432d263a583fa9c1599d6d"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30867910e32b5580b2d188d5dfe9910c3ad6a4b7fbedcbbda479d4246409fff5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f23d9c21121a813ca091bd2182c79109396899f881280e03f67be02a5175c11"
    sha256 cellar: :any_skip_relocation, monterey:       "ce7f4b81e76c51422bd763f7a49803ef73cccdb48149fda1640587c711eb5faa"
    sha256 cellar: :any_skip_relocation, big_sur:        "6bf7b515b825ab7ee5e84bf3c5a9e7de93d9f37ed4ad603ecb80541eb14077c4"
    sha256 cellar: :any_skip_relocation, catalina:       "f86d5fa19408c09dc28500b003d21c1d376d125ff332e4239288ab1e284c81ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1a4d1ee2a2cf35a17f9c9f03520d91aabced3c6fdfea8e81afe5913219e9e29"
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
