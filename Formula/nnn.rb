class Nnn < Formula
  desc "Free, fast, friendly file browser"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v1.5.tar.gz"
  sha256 "f50f59953c29408963bbb961891155bd0a1fe2072d4441cc0ff927b128725c7f"

  bottle do
    cellar :any_skip_relocation
    sha256 "686064429ad6c93882d66bbe0ee5e58e49371ab4405f7471b06727a611ce0303" => :high_sierra
    sha256 "116b742a578044fe4309cee847b72d15b0687c19887b8dd65bc1fac1a5d27eeb" => :sierra
    sha256 "26901989e2a66d9ec8806ea21b931e66ab8b6f4a1a35544b4da473a8b490e692" => :el_capitan
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
