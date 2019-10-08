class Nnn < Formula
  desc "Tiny, lightning fast, feature-packed file manager"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v2.7.tar.gz"
  sha256 "0592c7cbcf2cf66cacac49e9204636480820b1bc74e4187dd7ee06945a6d07c5"
  head "https://github.com/jarun/nnn.git"

  bottle do
    cellar :any
    sha256 "cf5f8858f95a2b09ead189bf89989a86e4f320a3d1892caf15cb98fd253d0ed4" => :catalina
    sha256 "312a3d50d38eda061638ea7e6b5c82f40e9f462eed882316c18bf20503c9bdae" => :mojave
    sha256 "f819fda84d7ba01e82d64549bd8846eb11299d63edc5a4a7bcbf2703a928ad7f" => :high_sierra
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
