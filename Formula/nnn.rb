class Nnn < Formula
  desc "Tiny, lightning fast, feature-packed file manager"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v4.1.1.tar.gz"
  sha256 "f0e02668da6324c12c39db35fe5c26bd45f3e02e5684a351b8ce8a357419ceba"
  license "BSD-2-Clause"
  head "https://github.com/jarun/nnn.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "cb56c6154458ccdf3ae64561deceb4ed9bbcad6a4f3780ea3ced54c338e55208"
    sha256 cellar: :any, big_sur:       "aa36cd7119f453030b9f22491161591d2829d84323b2c0b48a6943f43c696c1c"
    sha256 cellar: :any, catalina:      "74b507cd2385f85cabaabb1f0bc552908266e6fe1b69053c38920ed173a8b86f"
    sha256 cellar: :any, mojave:        "b9a20a6da7f9dcbaaa7605602df38df2d826d1118e01b9bdba40eccfa628900c"
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
