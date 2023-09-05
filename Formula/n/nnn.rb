class Nnn < Formula
  desc "Tiny, lightning fast, feature-packed file manager"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v4.9.tar.gz"
  sha256 "9e25465a856d3ba626d6163046669c0d4010d520f2fb848b0d611e1ec6af1b22"
  license "BSD-2-Clause"
  head "https://github.com/jarun/nnn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aedf2b937bfbc61834f9373386907ef9aef7e2c5582ee8b7fb189557937067de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a325f22a8f7d399aaa7d24cc7e92e72f26afbbdf122fae72fb4d4f435987142b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e49a1963570a2bf1ac43bd44a88a417dddd383c2cbe0636c7d331aa9726d143"
    sha256 cellar: :any_skip_relocation, ventura:        "d44bae7e9592cf3deeba0be69df4e7a79cb98aed93270ec16126fe12fc5d8189"
    sha256 cellar: :any_skip_relocation, monterey:       "6c5fbf8f266297f31e77e288dc8b1844854ac5e2ca5de6306951b41fde18327a"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e218da4b7158b4d7e14a1fcc95d26d2448e308e45a131d4e8b7540c1735c2c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a85922f41bf36871d8f31755c1d0de81011bff8de457350e7f3b2fbe1e881672"
  end

  depends_on "gnu-sed"
  depends_on "ncurses"
  depends_on "readline"

  def install
    system "make", "install", "PREFIX=#{prefix}"

    bash_completion.install "misc/auto-completion/bash/nnn-completion.bash"
    zsh_completion.install "misc/auto-completion/zsh/_nnn"
    fish_completion.install "misc/auto-completion/fish/nnn.fish"

    pkgshare.install "misc/quitcd"
  end

  test do
    # Test fails on CI: Input/output error @ io_fread - /dev/pts/0
    # Fixing it involves pty/ruby voodoo, which is not worth spending time on
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    # Testing this curses app requires a pty
    require "pty"

    (testpath/"testdir").mkdir
    PTY.spawn(bin/"nnn", testpath/"testdir") do |r, w, _pid|
      w.write "q"
      assert_match "~/testdir", r.read
    end
  end
end
