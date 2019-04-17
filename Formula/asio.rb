class Asio < Formula
  desc "Cross-platform C++ Library for asynchronous programming"
  homepage "https://think-async.com/Asio"
  url "https://downloads.sourceforge.net/project/asio/asio/1.12.2%20%28Stable%29/asio-1.12.2.tar.bz2"
  sha256 "4e27dcb37456ba707570334b91f4798721111ed67b69915685eac141895779aa"
  head "https://github.com/chriskohlhoff/asio.git"

  bottle do
    cellar :any
    sha256 "dafc1e63f716ff0117f0676c711e8946b7044e09847014fb8bec168ca04ec32f" => :mojave
    sha256 "ef5f33e16009ed897a3e70190312830be84df11c59ce3c45c2e1542f3054877d" => :high_sierra
    sha256 "32d870c762f699501ecdc7191888244e6aafca964f25b1690bb52d58793fe073" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  depends_on "openssl"

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
    found = [pkgshare/"examples/cpp11/http/server/http_server",
             pkgshare/"examples/cpp03/http/server/http_server"].select(&:exist?)
    raise "no http_server example file found" if found.empty?

    pid = fork do
      exec found.first, "127.0.0.1", "8080", "."
    end
    sleep 1
    begin
      assert_match /404 Not Found/, shell_output("curl http://127.0.0.1:8080")
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
