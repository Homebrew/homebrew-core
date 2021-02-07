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
    sha256 cellar: :any_skip_relocation, big_sur:     "a04e9592263251aa339a90a19f2664db2490656c835e766f9f1b09f854c3ea0a"
    sha256 cellar: :any_skip_relocation, catalina:    "ab2feae40a1c22695f88383fc0d25bd1ce90499cf74004719fbaf7540a673f09"
    sha256 cellar: :any_skip_relocation, mojave:      "50a7e6d5e3b6e0cdb75f9dd83fde8c9d473a632c8f22f575591fe4b5469a19bf"
    sha256 cellar: :any_skip_relocation, high_sierra: "530ae677663e9773d05a17878a1e28e91e8751d9b9ac8cffdb0acaad7a7d1e8b"
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
