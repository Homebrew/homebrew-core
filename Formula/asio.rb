class Asio < Formula
  desc "Cross-platform C++ Library for asynchronous programming"
  homepage "https://think-async.com/Asio"
  url "https://downloads.sourceforge.net/project/asio/asio/1.12.0%20%28Stable%29/asio-1.12.0.tar.bz2"
  sha256 "2c350b9ad7e266ab47935200a09194cbdf6f7ce2e3cabeddae6c68360d39d3ad"
  head "https://github.com/chriskohlhoff/asio.git"

  bottle do
    cellar :any
    sha256 "da6bcc10e894ac74f79546334dac00c3563bc9ce625425d813d14a925b5fe384" => :high_sierra
    sha256 "7efba40b78206a1895b39589db2ba9377d96a183f807304e27bec9d6008979ba" => :sierra
    sha256 "a8947a5dbf1ad0e68f1a0a87e38f07d1fef98c12498b93b157dc51ab30b60112" => :el_capitan
  end

  option "with-boost-coroutine", "Use Boost.Coroutine to implement stackful coroutines"

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  depends_on "boost" => :optional
  depends_on "boost" if build.with?("boost-coroutine")
  depends_on "openssl"

  needs :cxx11 if build.without? "boost"

  def install
    ENV.cxx11 if build.without? "boost"

    if build.head?
      cd "asio"
      system "./autogen.sh"
    else
      system "autoconf"
    end
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-boost=#{(build.with?("boost") || build.with?("boost-coroutine")) ? Formula["boost"].opt_include : "no"}
    ]
    args << "--enable-boost-coroutine" if build.with? "boost-coroutine"

    system "./configure", *args
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
