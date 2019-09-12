class Nnn < Formula
  desc "Tiny, lightning fast, feature-packed file manager"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v2.6.tar.gz"
  sha256 "17fd3e517308e41065594ffe8dcde348b4d10dea4240699f4708337db48b3e25"
  head "https://github.com/jarun/nnn.git"

  bottle do
    cellar :any
    sha256 "2f98d4bf73cd267231733f78ab69aedfdfb73c0146d7e6dec2ca1318d27d839c" => :mojave
    sha256 "8caf9cc2426b567d3590af0727fd9ad36989d68c85a47d1001c9d25e53ab1c76" => :high_sierra
    sha256 "9fb3b67e58030caee39602773a3f857e8aed0b0a39020b5fc96d3afb2f46c5f9" => :sierra
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
