class InteractiveRebaseTool < Formula
  desc "Native sequence editor for Git interactive rebase"
  homepage "https://gitrebasetool.mitmaro.ca/"
  url "https://github.com/MitMaro/git-interactive-rebase-tool/archive/1.1.0.tar.gz"
  sha256 "c4fa28f864f84e24e7d6253074e5409f49362a99e40f481f2187b5e6a79285f7"

  bottle do
    cellar :any_skip_relocation
    sha256 "e164819243e778c25f49adb1e0e9da7e1c94e2973a89c5df35188fe4eaf09567" => :mojave
    sha256 "24b07c849654699ac2ff0e827562fff88c947c45ca224440817ad580a9d91167" => :high_sierra
    sha256 "3d0f6aa7a3379829f3999eed234d303a22f81d1fa9b6fcb7aa070234c330246d" => :sierra
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
