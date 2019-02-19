class Nnn < Formula
  desc "Free, fast, friendly file browser"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v2.3.tar.gz"
  sha256 "eaad2ccf0d781aeeb38fdfc4ad75a0405ca3da4f82ded64cce766a74a2b299ab"
  head "https://github.com/jarun/nnn.git"

  bottle do
    cellar :any
    sha256 "8034008f55cf74e1a879f76d8a4fcc6b122775315b4cb6e12c2d2b04f2309ac4" => :mojave
    sha256 "d426791d4d46d8faf6868e31c0a6e7437fc91992fdad37607ef8a521c58c734c" => :high_sierra
    sha256 "db24f722a873140405e9546019e390af3b07452425a82b3e4eef3f854c1192b0" => :sierra
  end

  depends_on "readline"

  def install
    system "make", "install", "PREFIX=#{prefix}"

    bash_completion.install "scripts/auto-completion/bash/nnn-completion.bash"
    zsh_completion.install "scripts/auto-completion/zsh/_nnn"
    fish_completion.install "scripts/auto-completion/fish/nnn.fish"
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
