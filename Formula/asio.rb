class Asio < Formula
  desc "Cross-platform C++ Library for asynchronous programming"
  homepage "https://think-async.com/Asio"
  url "https://downloads.sourceforge.net/project/asio/asio/1.18.0%20%28Stable%29/asio-1.18.0.tar.bz2"
  sha256 "9d539e7c09aa6394d512c433c5601c1f26dc4975f022ad7d5e8e57c3b635b370"
  license "BSL-1.0"
  head "https://github.com/chriskohlhoff/asio.git"

  bottle do
    cellar :any
    sha256 "1c2a224aa3c62fdf4d6f80b54c3297e38992c53a25f977b2492c4de37848c34f" => :catalina
    sha256 "aac238cdd1c834dace440c7dd42cd410bfc1908a62b0710ec54ef4e3b1100a40" => :mojave
    sha256 "a25de24a946f9e0a28a4ed33271bb577a356997052ece5eaa46036f7f5863c1a" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "openssl@1.1"

  def install
    ENV.cxx11

    if build.head?
      cd "asio"
      system "./autogen.sh"
    else
      system "autoconf"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-boost=no"
    system "make", "install"
    pkgshare.install "src/examples"
  end

  test do
    found = Dir[pkgshare/"examples/cpp{11,03}/http/server/http_server"]
    raise "no http_server example file found" if found.empty?

    port = free_port
    pid = fork do
      exec found.first, "127.0.0.1", port.to_s, "."
    end
    sleep 1
    begin
      assert_match /404 Not Found/, shell_output("curl http://127.0.0.1:#{port}")
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
