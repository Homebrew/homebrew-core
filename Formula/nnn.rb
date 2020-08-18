class Nnn < Formula
  desc "Tiny, lightning fast, feature-packed file manager"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v3.4.tar.gz"
  sha256 "7803ae6e974aeb4008507d9d1afbcca8d084a435f36ff636b459ca50414930a1"
  license "BSD-2-Clause"
  head "https://github.com/jarun/nnn.git"

  bottle do
    cellar :any
    sha256 "0974658c7c0315c30083f3db92cc37b34bbc2600c4b80392c6fa0124eb96509a" => :catalina
    sha256 "0fb61b265b7f5a99ce30b930141531b55d789959de46d625b209c2238529df33" => :mojave
    sha256 "5c04648426900cf44dbf1207f0fd36f8a003e30a6362a6606ae7a9bb58a495b0" => :high_sierra
  end

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
