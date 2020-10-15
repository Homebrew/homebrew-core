class Nnn < Formula
  desc "Tiny, lightning fast, feature-packed file manager"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v3.4.tar.gz"
  sha256 "7803ae6e974aeb4008507d9d1afbcca8d084a435f36ff636b459ca50414930a1"
  license "BSD-2-Clause"
  head "https://github.com/jarun/nnn.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "44109c19d7e9c4108538ed3fc5a75c3ae176cdecaf64d19d194ccf4802aa6354" => :catalina
    sha256 "a8dd428c9cbdea23be4b13493edfe09583814adbdee2d49627812268481af7df" => :mojave
    sha256 "e0d170451efa4edb22b8899577ee1bd0fb2f5cac90218fcc021f20514ef52ece" => :high_sierra
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
