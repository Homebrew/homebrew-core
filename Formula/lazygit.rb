class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.18.tar.gz"
  sha256 "48f44051cacab508ca53cc2c3aaeabc01b61b4a02379bac1a0eb8be630a7af51"

  bottle do
    cellar :any_skip_relocation
    sha256 "f5723dd97f71b992c7d7a5e0f020f7ab9bb3be7f263caa543193a0bd6a918312" => :catalina
    sha256 "507418062211a1a19e2730b0d6988009600f17ed6f8484e3c5208f079bbfe98d" => :mojave
    sha256 "cd7ea89e2b1bc69a079de935ddf0e0548acc700a6aaf4667db253667d5a4ed9f" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-o", bin/"lazygit",
      "-ldflags", "-X main.version=#{version} -X main.buildSource=homebrew"
  end

  # lazygit is a terminal GUI, but it can be run in 'client mode' for example to write to git's todo file
  test do
    (testpath/"git-rebase-todo").write ""
    ENV["LAZYGIT_CLIENT_COMMAND"] = "INTERACTIVE_REBASE"
    ENV["LAZYGIT_REBASE_TODO"] = "foo"
    system "#{bin}/lazygit", "git-rebase-todo"
    assert_match "foo", (testpath/"git-rebase-todo").read
  end
end
