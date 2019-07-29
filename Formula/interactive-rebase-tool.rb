class InteractiveRebaseTool < Formula
  desc "Native sequence editor for Git interactive rebase"
  homepage "https://gitrebasetool.mitmaro.ca/"
  url "https://github.com/MitMaro/git-interactive-rebase-tool/archive/1.0.0.tar.gz"
  sha256 "74dc96e59820bd3352984618d307d9b4de2e257aed65d0c8b3118580ffb6da56"

  bottle do
    cellar :any_skip_relocation
    sha256 "6109668cf960bebee20d6412aa468c608d00ce71213b3a18087c0b27f7af08d4" => :mojave
    sha256 "a68156fe2a1693509a89656b4e4bf7d887e9bc41aa4472bc8ea32fba8b7b1f00" => :high_sierra
    sha256 "b88696e2077e06c1eddeb783f6230fff7dddd920442ebf5aa0b5ba5b0197541c" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    require "pty" # required for interactivity
    mkdir testpath/"repo" do
      system "git", "init"
      touch "FILE1"
      system "git", "add", "FILE1"
      system "git", "commit", "--date='2005-04-07T22:13:13-3:30'", "--author='Test <test@example.com>'", "--message='File 1'"
      touch "FILE2"
      system "git", "add", "FILE2"
      system "git", "commit", "--date='2005-04-07T22:13:13-3:30'", "--author='Test <test@example.com>'", "--message='File 2'"
    end

    (testpath/"repo/.git/rebase-merge/git-rebase-todo").write <<~EOS
      pick be5eaa0 File 1
      pick 32bd1bb File 2
    EOS

    expected_git_rebase_todo = <<~EOS
      drop be5eaa0 File 1
      pick 32bd1bb File 2
    EOS

    PTY.spawn({ "GIT_DIR" => testpath/"repo/.git/" }, bin/"interactive-rebase-tool", testpath/"repo/.git/rebase-merge/git-rebase-todo") do |stdout, stdin, _pid|
      # simulate user input
      stdin.putc "d"
      stdin.putc "W"
      stdout.read
    end

    assert_equal expected_git_rebase_todo, (testpath/"repo/.git/rebase-merge/git-rebase-todo").read
  end
end
