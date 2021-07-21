class Nnn < Formula
  desc "Tiny, lightning fast, feature-packed file manager"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v4.2.tar.gz"
  sha256 "5675f9fe53bddfd92681ef88bf6c0fab3ad897f9e74dd6cdff32fe1fa62c687f"
  license "BSD-2-Clause"
  head "https://github.com/jarun/nnn.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "cb56c6154458ccdf3ae64561deceb4ed9bbcad6a4f3780ea3ced54c338e55208"
    sha256 cellar: :any,                 big_sur:       "aa36cd7119f453030b9f22491161591d2829d84323b2c0b48a6943f43c696c1c"
    sha256 cellar: :any,                 catalina:      "74b507cd2385f85cabaabb1f0bc552908266e6fe1b69053c38920ed173a8b86f"
    sha256 cellar: :any,                 mojave:        "b9a20a6da7f9dcbaaa7605602df38df2d826d1118e01b9bdba40eccfa628900c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ee55c27f8a66e1a8175cd3f2d544481e8727a5d4996df3d0f213bf1e76da0c4"
  end

  depends_on "gnu-sed"
  depends_on "readline"

  uses_from_macos "ncurses"

  def install
    system "make", "install", "PREFIX=#{prefix}"

    bash_completion.install "misc/auto-completion/bash/nnn-completion.bash"
    zsh_completion.install "misc/auto-completion/zsh/_nnn"
    fish_completion.install "misc/auto-completion/fish/nnn.fish"
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
    cd testpath/"testdir" do
      PTY.spawn(bin/"nnn") do |r, w, _pid|
        w.write "q"
        assert_match "~/testdir", r.read
      end
    end
  end
end
