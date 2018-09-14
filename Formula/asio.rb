class Asio < Formula
  desc "Cross-platform C++ Library for asynchronous programming"
  homepage "https://think-async.com/Asio"
  url "https://downloads.sourceforge.net/project/asio/asio/1.12.1%20%28Stable%29/asio-1.12.1.tar.bz2"
  sha256 "a9091b4de847539fa5b2259bf76a5355339c7eaaa5e33d7d4ae74d614c21965a"
  head "https://github.com/chriskohlhoff/asio.git"

  bottle do
    cellar :any
    sha256 "49e8f4686ca26f77e22ffc4ef9fe5715b402bb14bdc118c87a9bfe0a3e0f348c" => :mojave
    sha256 "65892f6827794887cb8ace02435bdbce35e213b74e3c8acfc157a9f5ef41f239" => :high_sierra
    sha256 "6564529f098c6f936c7b57aaf562c396f89bc4e8b13018b1bf395502616b4b92" => :sierra
    sha256 "fbb2170a86dcb1af7b899e0a877dd5351ae891abf3a3bc82e0afc7ce3b5dfa24" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  depends_on "openssl"

  needs :cxx11

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
