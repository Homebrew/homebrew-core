class InteractiveRebaseTool < Formula
  desc "Native sequence editor for Git interactive rebase"
  homepage "https://gitrebasetool.mitmaro.ca/"
  url "https://github.com/MitMaro/git-interactive-rebase-tool/archive/1.2.0.tar.gz"
  sha256 "0dc328575d03fb160f0222d594ab26b540aa257c8be41f5d6ba854bd5876a171"

  bottle do
    cellar :any_skip_relocation
    sha256 "5c39969f4e0f4d322317e4e9ce4338c376374178858ae0e2bf47322fea9b5768" => :catalina
    sha256 "d5906a9f52376adc5c3ea5a48431f2928451bd801dc1bf6a89bd5f603de08e82" => :mojave
    sha256 "0228140f6c111c0982983757373b55bd4ebdda48dc6eb142a1b22585a66e1277" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
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
