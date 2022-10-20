class GitInteractiveRebaseTool < Formula
  desc "Native sequence editor for Git interactive rebase"
  homepage "https://gitrebasetool.mitmaro.ca/"
  url "https://github.com/MitMaro/git-interactive-rebase-tool/archive/2.2.1.tar.gz"
  sha256 "86f262e6607ac0bf5cee22ca1b333cf9f827e09d3257658d525a518aa785ca7c"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b9727e1d5aec0e849818716a0fa4f14c6d02acb328ccd63948e722f654fc2c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e88ba510f016b5dbdefceabde27bc5936a5deafbda134cfd8506431d0ddff15"
    sha256 cellar: :any_skip_relocation, monterey:       "82c9e95663d8c05cf158893598efced283ed431b13a4e68bd480daff9710d904"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f010ca910bc6f593c2f1eaa4721da475c78714c26e7376971b7b41eed0e5191"
    sha256 cellar: :any_skip_relocation, catalina:       "5d875c81fc6d2167cd343ade0f984ea08a870313199f5673fa947a4c7b0c8fb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8f2a282a775c0141646641ac96e532e0e59a088a0a6a93dd0f877a39d94217e"
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
