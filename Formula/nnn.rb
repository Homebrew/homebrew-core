class Nnn < Formula
  desc "Tiny, lightning fast, feature-packed file manager"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v3.4.tar.gz"
  sha256 "7803ae6e974aeb4008507d9d1afbcca8d084a435f36ff636b459ca50414930a1"
  license "BSD-2-Clause"
  head "https://github.com/jarun/nnn.git"

  bottle do
    cellar :any
    sha256 "db823ba37ee3cf5c16a06d5dcf84307ec7b0dc2dc7c83d9ee9cdd87755c06856" => :catalina
    sha256 "cc21b0159efe6087265de581033cb6737ceee1613c2857c613408b3da6ff1aa6" => :mojave
    sha256 "5ec7be04b6cce16cf8b14bd365fce2628e6438e09233cd62311c34227631f2cd" => :high_sierra
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
