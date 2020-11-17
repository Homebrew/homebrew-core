class Nnn < Formula
  desc "Tiny, lightning fast, feature-packed file manager"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v3.5.tar.gz"
  sha256 "e636d4035499a112a0ad33f1557838132ed2e39d8857c5b219714fe9f64681f3"
  license "BSD-2-Clause"
  head "https://github.com/jarun/nnn.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "bbf47e736eb8f34bee3fb1a69b2c80fa78bef2d3fb80105990471ef26902ff73" => :big_sur
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
