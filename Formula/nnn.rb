class Nnn < Formula
  desc "Tiny, lightning fast, feature-packed file manager"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v4.1.1.tar.gz"
  sha256 "f0e02668da6324c12c39db35fe5c26bd45f3e02e5684a351b8ce8a357419ceba"
  license "BSD-2-Clause"
  head "https://github.com/jarun/nnn.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "579d4e29404efe54b2b676e8cb5b4704e5f13edc94fc6a3756e2ada28f16150c"
    sha256 cellar: :any, big_sur:       "3c1f82679a6d5c71c0923589533adf92b576338aad286b514f45f266b8cc595d"
    sha256 cellar: :any, catalina:      "a9a9a0a12eaeb1726643c0108f22ac8394263d3d3a0a42b7a79b3818392f79c4"
    sha256 cellar: :any, mojave:        "6ecf85fd92906d8e0dbd27538041dcb3e11d14a112d9bde6adb85c5a8fdf81d5"
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
