class Notcurses < Formula
  desc "Blingful character graphics/TUI library"
  homepage "https://nick-black.com/dankwiki/index.php/Notcurses"
  url "https://github.com/dankamongmen/notcurses/archive/refs/tags/v3.0.17.tar.gz"
  sha256 "b0fbe824984fe25b5a16770dbd00b85d44db5d09cc35bd881b95335d0db53128"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 arm64_golden_gate: "1805b35927a23108423ad9daa3fa14c22b1aa0c1b92c65d19446e9c30ad79ce3"
    sha256 arm64_tahoe:       "72fa1bc62c690ea45bd73aa85b4069bf985df296feca92939af58d66e0d5c275"
    sha256 arm64_sequoia:     "ae331c32f083fa9c66efc7bb2e36a0aa6441a46abee5b39a27745a79b03810ae"
    sha256 arm64_sonoma:      "547beec7e3f5d061f7e0992e0f9da8879b4ed4f16feb8bc5bf58f499dcbf3d5e"
    sha256 sonoma:            "93dd544af9a892d6110c4bba3cae824e0b12c4b00cd526d47916a99b62e98e98"
    sha256 arm64_linux:       "a475788ca97139fa95fc2a0ab167b678661423809b89e3b048a213418b3efd49"
    sha256 x86_64_linux:      "fe48008efcea988d1cf546d99e67b0970f45ab4eedff226081a7cd1e81ba6e25"
  end

  depends_on "cmake" => :build
  depends_on "doctest" => :build
  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "libdeflate"
  depends_on "libunistring"
  depends_on "ncurses"

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    require "pty"

    # Notcurses rejects dumb terminals; it opens `/dev/tty`, so give it its own PTY to avoid SIGTTOU
    ENV["TERM"] = "dumb"
    output_log = testpath/"output.log"
    PTY.spawn(bin/"notcurses-info", [:out, :err] => output_log.to_s) do |r, _w, pid|
      r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      Process.wait(pid)
    end
    assert_equal 1, $CHILD_STATUS.exitstatus
    assert_match "required terminfo capability 'cup' not defined", output_log.read
  end
end
