class Nnn < Formula
  desc "Free, fast, friendly file browser"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v1.4.tar.gz"
  sha256 "f1170864c26e55d89034d555572484950998fa6d99784237d76cd4e3bf45aed8"

  bottle do
    cellar :any_skip_relocation
    sha256 "1b9b77488be80d90fd6b90c7ed8c93df02cad18211321ba8199c629d693b5e27" => :sierra
    sha256 "a5c1d353bdb32b395f827a3b86da9fa3f7336737063531cc5862eaf80fff7d2d" => :el_capitan
    sha256 "d10bca08ca2a0dde952c1704eac053210a6e1a0bcb44daf7447866f15b8397ba" => :yosemite
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Testing this curses app requires a pty
    require "pty"
    PTY.spawn(bin/"nnn") do |r, w, _pid|
      w.write "q"
      assert_match "cwd: #{testpath.realpath}", r.read
    end
  end
end
