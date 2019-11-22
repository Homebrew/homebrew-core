class InteractiveRebaseTool < Formula
  desc "Native sequence editor for Git interactive rebase"
  homepage "https://gitrebasetool.mitmaro.ca/"
  url "https://github.com/MitMaro/git-interactive-rebase-tool/archive/1.1.0.tar.gz"
  sha256 "c4fa28f864f84e24e7d6253074e5409f49362a99e40f481f2187b5e6a79285f7"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "29c07ab1c4efc97c65213815a8e770dec18574435135ce515f1701ce9e989cdc" => :catalina
    sha256 "7633dcbb333d144ff73119623b6d181b864a87ea124048e64d26465fdc99fba7" => :mojave
    sha256 "01edbef9fae206778e3e0e14c1612869a4490a054910f5181ee6537150e3767a" => :high_sierra
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
