class Nnn < Formula
  desc "Tiny, lightning fast, feature-packed file manager"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v4.7.tar.gz"
  sha256 "81ccccc045bfd7ee3f1909cc443158ea0d1833f77d6342fd19c33864a2ab71d1"
  license "BSD-2-Clause"
  head "https://github.com/jarun/nnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c1d82b403f9f550f94e9e8b4cc5abf1db5df22b9d8e8e4a03537db8669385079"
    sha256 cellar: :any,                 arm64_monterey: "ddfc52b2869147d312f704b9bd685bf632893e4ab6d7208dc26d56e4d2189b18"
    sha256 cellar: :any,                 arm64_big_sur:  "58acdcf48c4387489175a0623d7ad9706f61f7a7811ba1a19b3115c7943badec"
    sha256 cellar: :any,                 ventura:        "9dcc0fa3d19a7472c923fe31e5c4997b1c8519800d6ecfa4ed3fa093d81702c9"
    sha256 cellar: :any,                 monterey:       "764019065dee7ecbfaf671c4fcdd1557680dea3b613a66e388b06f366e96faa4"
    sha256 cellar: :any,                 big_sur:        "5988f897c440cc93e3ef016af38214ea7af8ca4bc1543ee1f999e9b94a84922e"
    sha256 cellar: :any,                 catalina:       "6090e2f17a65c2b57ee27a3f285c14c6a7d06b399b869373db41e6dd323f5bc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8747361033237d3ffa712ec076e5478559de36e104c4625964f2ad0de1d886ab"
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
