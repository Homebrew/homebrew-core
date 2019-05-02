class InteractiveRebaseTool < Formula
  desc "Native sequence editor for Git interactive rebase"
  homepage "https://gitrebasetool.mitmaro.ca/"
  url "https://github.com/MitMaro/git-interactive-rebase-tool/archive/1.0.0.tar.gz"
  sha256 "74dc96e59820bd3352984618d307d9b4de2e257aed65d0c8b3118580ffb6da56"

  bottle do
    cellar :any
    sha256 "dcf42e55363693fb261582901be1447ce5230504353ccaca773cbc6261fc456c" => :mojave
    sha256 "693a7b57bb2ea854153cfa49d18099e1c56ff06edcf1fc1a0ee8486665a3c70e" => :high_sierra
    sha256 "9673e43caccc0d51939cfdab6bf8ebf03b7e2a4d6c46eaf7ac9e70f0727ea9aa" => :sierra
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
