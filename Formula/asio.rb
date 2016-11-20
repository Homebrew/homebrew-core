class Asio < Formula
  desc "Cross-platform C++ Library for asynchronous programming"
  homepage "https://think-async.com/Asio"
  url "https://downloads.sourceforge.net/project/asio/asio/1.10.8%20%28Stable%29/asio-1.10.8.tar.bz2"
  sha256 "26deedaebbed062141786db8cfce54e77f06588374d08cccf11c02de1da1ed49"
  head "https://github.com/chriskohlhoff/asio.git"

  bottle do
    sha256 "d04083730696f64cd35ae80facad12694187fa7f01034a386b073e28a00c2b02" => :sierra
    sha256 "0bf0884092e11e20b4b031da98945bfefd68f2ec132a19e159f56e433afb9a76" => :el_capitan
    sha256 "8da6c82750bd572c5c14cb1c45953e03b9f1d0e3783ac2aca358288ee8c01dde" => :yosemite
  end

  devel do
    url "https://downloads.sourceforge.net/project/asio/asio/1.11.0%20%28Development%29/asio-1.11.0.tar.bz2"
    sha256 "4f7e13260eea67412202638ec111cb5014f44bdebe96103279c60236874daa50"
  end

  option "with-boost-coroutine", "Use Boost.Coroutine to implement stackful coroutines"
  option :cxx11

  needs :cxx11 if build.cxx11?

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  if !build.cxx11? || build.with?("boost-coroutine")
    depends_on "boost"
  else
    depends_on "boost" => :optional
  end
  depends_on "openssl"

  def install
    ENV.cxx11 if build.cxx11?
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
      --with-boost=#{(build.with?("boost") || build.with?("boost-coroutine") || !build.cxx11?) ? Formula["boost"].opt_include : "no"}
    ]
    args << "--enable-boost-coroutine" if build.with? "boost-coroutine"

    system "./configure", *args
    system "make", "install"
    pkgshare.install "src/examples"
  end

  test do
    httpserver = pkgshare/"examples/cpp03/http/server/http_server"
    pid = fork do
      exec httpserver, "127.0.0.1", "8080", "."
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
