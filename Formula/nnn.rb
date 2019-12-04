class Nnn < Formula
  desc "Tiny, lightning fast, feature-packed file manager"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v2.8.1.tar.gz"
  sha256 "cadf9cf8038433aeeb50a777180ad4b309ac7d2fec81c7da177ddca515812f06"
  head "https://github.com/jarun/nnn.git"

  bottle do
    cellar :any
    sha256 "c1515b3bba6dfda3f7d51e3b2ba809c3b40645401ea9a9fc2c8c586c1a134ee0" => :catalina
    sha256 "f823d5d0d38f52cf8f861bcd21068a99206617c78d9f6996078cc5e91229bc0f" => :mojave
    sha256 "c3aa4496f3916945ce62abd17288da0e090da6fa1fd8b8381d4992fce6b0ee54" => :high_sierra
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
