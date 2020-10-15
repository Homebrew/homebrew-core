class Asio < Formula
  desc "Cross-platform C++ Library for asynchronous programming"
  homepage "https://think-async.com/Asio"
  url "https://downloads.sourceforge.net/project/asio/asio/1.18.0%20%28Stable%29/asio-1.18.0.tar.bz2"
  sha256 "9d539e7c09aa6394d512c433c5601c1f26dc4975f022ad7d5e8e57c3b635b370"
  license "BSL-1.0"
  head "https://github.com/chriskohlhoff/asio.git"

  livecheck do
    url :stable
    regex(%r{url=.*?Stable.*?/asio[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    cellar :any
    sha256 "89dff3c575014d571875ebaf43772705c605f95ed9424a235a7755b13d523c37" => :catalina
    sha256 "46d36e13b0f13a1d0e02be143bb96f244fecbc3525d1ca8fcb560b1a8ecaf095" => :mojave
    sha256 "f074033735a3dab5d4d6962aab8f9b948dcc6d2148b74fe3706f4d35def11cff" => :high_sierra
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
