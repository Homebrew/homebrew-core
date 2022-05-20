class GitInteractiveRebaseTool < Formula
  desc "Native sequence editor for Git interactive rebase"
  homepage "https://gitrebasetool.mitmaro.ca/"
  url "https://github.com/MitMaro/git-interactive-rebase-tool/archive/2.2.0.tar.gz"
  sha256 "4d60912c64a1ea25ff3e8a4beca0ecdb6a1c761f81e06f81ebc2a46119b8780c"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8268602e97428a2533d221f653b1ecca35e22918f35553976fbb947bed703549"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7dc2093b0fb7fb8f7ae2d112ce8e40500b551e52840fea6f0731bdbce403a006"
    sha256 cellar: :any_skip_relocation, monterey:       "ccf03c66468ccd6bce8e919fae15e3f457a05868c107073df3c4ffaaf4562d41"
    sha256 cellar: :any_skip_relocation, big_sur:        "dab98f6b284755fe1260117a7685a4ad8eb8682297ce7ab273b7e4ef33bfcdb9"
    sha256 cellar: :any_skip_relocation, catalina:       "f348f038f063d183460b771be3c560b7f6432449e6ebdad34f4020b2ffb3ec33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c701dfa6e0e93a75d8b0f17ad3513bb816922ab333906d71ad93d87f3599b78"
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
