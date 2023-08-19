class GitInteractiveRebaseTool < Formula
  desc "Native sequence editor for Git interactive rebase"
  homepage "https://gitrebasetool.mitmaro.ca/"
  url "https://github.com/MitMaro/git-interactive-rebase-tool/archive/2.3.0.tar.gz"
  sha256 "4af63703b3504370ef298693abc5061fe5bf215536e6d45952afda33a92f8101"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1fd3d07fa97db3fa78fa3692d55639319d37c215f87dd2602df938059eb57919"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95392c47907085f0970c680ee9413c427bff5fb5ab2355c50d1f5cb71f50e963"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd8e36d75be1cb00efa1837df471e4ac970a60e5667bf3cdcd714c0cdb961b41"
    sha256 cellar: :any_skip_relocation, ventura:        "f972a3c5408ec3ba45bf072209e5a2c974c0c219be595dd074a5c4363ce2f735"
    sha256 cellar: :any_skip_relocation, monterey:       "9f9e1b520e626632725b75e254ee43c7778f9eab9c462e400a2e872378134e7d"
    sha256 cellar: :any_skip_relocation, big_sur:        "060a6d4d3ad11c25721d86e4ae00729b8a8019ea8d8e9b6edadbcf3e993e6cc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa8408b90bbd094f1e96cac2af2c01ddafccc49ad89cbf4b714457a26b70a9bf"
  end

  depends_on "pkg-config" => :build
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
