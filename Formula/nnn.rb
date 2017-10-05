class Nnn < Formula
  desc "Free, fast, friendly file browser"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v1.5.tar.gz"
  sha256 "f50f59953c29408963bbb961891155bd0a1fe2072d4441cc0ff927b128725c7f"

  bottle do
    cellar :any_skip_relocation
    sha256 "e8c2e37730942ff7e4f7df409557c77e8d50eb5d2719e874cf060015d102d1b4" => :high_sierra
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
