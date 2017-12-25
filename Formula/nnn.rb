class Nnn < Formula
  desc "Free, fast, friendly file browser"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v1.6.tar.gz"
  sha256 "e8b10a3b9847ba7ad3317f608691aaebcdaf2b67219d732f7a5d468221d3e83e"

  bottle do
    cellar :any_skip_relocation
    sha256 "686064429ad6c93882d66bbe0ee5e58e49371ab4405f7471b06727a611ce0303" => :high_sierra
    sha256 "116b742a578044fe4309cee847b72d15b0687c19887b8dd65bc1fac1a5d27eeb" => :sierra
    sha256 "26901989e2a66d9ec8806ea21b931e66ab8b6f4a1a35544b4da473a8b490e692" => :el_capitan
  end

  depends_on "readline"

  def install
    system "make", "install", "PREFIX=#{prefix}"
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
