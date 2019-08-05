class Nnn < Formula
  desc "Tiny, lightning fast, feature-packed file manager"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v2.6.tar.gz"
  sha256 "17fd3e517308e41065594ffe8dcde348b4d10dea4240699f4708337db48b3e25"
  head "https://github.com/jarun/nnn.git"

  bottle do
    cellar :any
    sha256 "c032ece32ca1970c4a4224c246255191c42dac2f6ab6d6350dd87dc0770bf9a6" => :mojave
    sha256 "161ac6aad7a8a4e1441dd8d2eee8ff8024f9f827c452ffe8504e83a6cfc9a6cf" => :high_sierra
    sha256 "614a1b1a101ff166305e09052e3ed2e6422375637c00353b1f285b3c57aaf55c" => :sierra
  end

  depends_on "readline"

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
