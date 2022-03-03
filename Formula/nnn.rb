class Nnn < Formula
  desc "Tiny, lightning fast, feature-packed file manager"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v4.4.tar.gz"
  sha256 "e04a3f0f0c2af1e18cb6f005d18267c7703644274d21bb93f03b30e4fd3d1653"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/jarun/nnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0f206ccff6782172f2eafd1499cdc463b210cb00148b22abb5bc73a9676434c4"
    sha256 cellar: :any,                 arm64_big_sur:  "8e0c86615ad8945427658c6886a7b223b8dd68fc7d3a317de19dede97c3a114f"
    sha256 cellar: :any,                 monterey:       "12ad9fecb2c396e1279a343730dd2bb31ffb294d6e22e11dbf4e0a6e01ea0493"
    sha256 cellar: :any,                 big_sur:        "2201c369d5254ccdd7425e1ad70363f587e9669ab0f45f16ac5a440fc5bb59db"
    sha256 cellar: :any,                 catalina:       "e05ba96826682aebd0f64f22399b953ab32319b9ef9325a5bee6340ecdbf5dab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74c98fb8821d85c71097acd3de33468c6f0fecdce11b7738b28063213d643058"
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
    on_linux do
      # Test fails on CI: Input/output error @ io_fread - /dev/pts/0
      # Fixing it involves pty/ruby voodoo, which is not worth spending time on
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

    # Testing this curses app requires a pty
    require "pty"

    (testpath/"testdir").mkdir
    PTY.spawn(bin/"nnn", testpath/"testdir") do |r, w, _pid|
      w.write "q"
      assert_match "~/testdir", r.read
    end
  end
end
