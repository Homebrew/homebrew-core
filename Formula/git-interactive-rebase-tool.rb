class GitInteractiveRebaseTool < Formula
  desc "Native sequence editor for Git interactive rebase"
  homepage "https://gitrebasetool.mitmaro.ca/"
  url "https://github.com/MitMaro/git-interactive-rebase-tool/archive/2.0.0.tar.gz"
  sha256 "572815b6bf152cae9414635caf9c8c918a575747c3a8885767380da4aeeeb709"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "372e9db83f4c4e47a7268c380e83346884901e3323cab736ba8e6e2a6fd523be"
    sha256 cellar: :any_skip_relocation, catalina: "dbb362bd82f3863f68aaa26591cd0754070f91c6573556e86210b63034fe47b0"
    sha256 cellar: :any_skip_relocation, mojave:   "06a54c67aa4daa0187733cb43a8ce3fcadd0d9a3aa3f8577dbd77f13e1128da5"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    require "io/console"

    mkdir testpath/"repo" do
      system "git", "init"
    end

    (testpath/"repo/.git/rebase-merge/git-rebase-todo").write <<~EOS
      noop
    EOS

    expected_git_rebase_todo = <<~EOS
      noop
    EOS

    env = { "GIT_DIR" => testpath/"repo/.git/" }
    executable = bin/"interactive-rebase-tool"
    todo_file = testpath/"repo/.git/rebase-merge/git-rebase-todo"

    _, _, pid = PTY.spawn(env, executable, todo_file)
    Process.wait(pid)

    assert_equal 0, $CHILD_STATUS.exitstatus
    assert_equal expected_git_rebase_todo, todo_file.read
  end
end
