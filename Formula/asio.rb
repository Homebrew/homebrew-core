class Asio < Formula
  desc "Cross-platform C++ Library for asynchronous programming"
  homepage "https://think-async.com/Asio"
  url "https://downloads.sourceforge.net/project/asio/asio/1.18.1%20%28Stable%29/asio-1.18.1.tar.bz2"
  sha256 "4af9875df5497fdd507231f4b7346e17d96fc06fe10fd30e2b3750715a329113"
  license "BSL-1.0"
  head "https://github.com/chriskohlhoff/asio.git"

  livecheck do
    url :stable
    regex(%r{url=.*?Stable.*?/asio[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "9cf6b9d1a1cc605977a853af92d5fd65a21f20a6128126ad19d8cceabc766a4b" => :big_sur
    sha256 "f335dcfcae4e9345a6510d06cafe8884a8368a43368d52e53f95e1ca6bb8699c" => :arm64_big_sur
    sha256 "a3eec5329a66d0e7017f407d653adc6234f09f20de691cb4290a5f1ca16c6c94" => :catalina
    sha256 "1cbf161c11f1f4863d39d190d61a6c8efc0cdb2932c3763df7ff1111c480aaae" => :mojave
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
