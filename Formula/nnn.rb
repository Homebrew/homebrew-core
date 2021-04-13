class Nnn < Formula
  desc "Tiny, lightning fast, feature-packed file manager"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v4.0.tar.gz"
  sha256 "a219ec8fad3dd0512aadae5840176f3265188c4c22da3b17b133bac602b40754"
  license "BSD-2-Clause"
  head "https://github.com/jarun/nnn.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "5ca4709e5e36ba33a918fc97de5a59974e53063a1396a86a2c75ab60fe8d0fe0"
    sha256 cellar: :any, big_sur:       "2c4b71eb676df77ab8da04b65ca8db6fcd0ba0f7eecb7ca92c877a230f226a4b"
    sha256 cellar: :any, catalina:      "d9f73d203fc5ed3c0edff51d598f723c20994d4da282a842ad63895b3da0e5da"
    sha256 cellar: :any, mojave:        "f7f88fa6e04a6ca1b41959ef4a4bc6d38351d0bf7be7784245a10e5508de1583"
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
    # Testing this curses app requires a pty
    require "pty"

    PTY.spawn(bin/"nnn") do |r, w, _pid|
      w.write "q"
      assert_match testpath.realpath.to_s, r.read
    end
  end
end
