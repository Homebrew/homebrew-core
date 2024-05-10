class GitInteractiveRebaseTool < Formula
  desc "Native sequence editor for Git interactive rebase"
  homepage "https://gitrebasetool.mitmaro.ca/"
  url "https://github.com/MitMaro/git-interactive-rebase-tool/archive/refs/tags/2.3.0.tar.gz"
  sha256 "4af63703b3504370ef298693abc5061fe5bf215536e6d45952afda33a92f8101"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ed399366f8adb76ce2f58488ccd962a8ef16447f6290b5f229f4c9dc3daf883"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c2a767bc773ffcbc636fbd55af0aeaf23bd69b07111413161f2a574c5224cbb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "828c794f3ee0e7e402a83ce15a897327d9760cd78156a5cce665f1e545dd2020"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "529cdbf5aa5ddda0b1aeb19d09fc506e5d605167b12930ba24374b9543db8eab"
    sha256 cellar: :any_skip_relocation, sonoma:         "b6bd256d7ab001da82c749b08cbd793ed902d3ca8cb09f2e9665e27b3c619572"
    sha256 cellar: :any_skip_relocation, ventura:        "9e609bed5b3c38e26f9b1c15f5ebd6d033f26cba28cf60462efd828ce6e27944"
    sha256 cellar: :any_skip_relocation, monterey:       "4bae4961c755dd4995ac74a33099d9fd47b0ac24a25d0702959d6f4f953049d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c3252f9714a5b51fb5f7237087dd3e9a0029ab63fd03c0a1d3f6e41829356da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36d0dd310b6ed752543b98dc359f904606306099b719667099cfd6fe85eb84c4"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  # build patch to compile with rust 1.77.0+
  # upstream PR ref, https://github.com/MitMaro/git-interactive-rebase-tool/pull/907
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/eef8b6250a14aa76c60ad013b676b1d45831ea2c/git-interactive-rebase-tool/2.3.0.patch"
    sha256 "1c5177347a4bb036f1c2485d7eb16c1a7cdf43d77e12e38bc67751cea8aaf1f9"
  end

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
