class Asio < Formula
  desc "Cross-platform C++ Library for asynchronous programming"
  homepage "https://think-async.com/Asio"
  url "https://downloads.sourceforge.net/project/asio/asio/1.16.0%20%28Stable%29/asio-1.16.0.tar.bz2"
  sha256 "14a8bfbe55410cbfff6fd97c81c760ce1a4e6cee45b49a7f293e1d7d79d17c0d"
  head "https://github.com/chriskohlhoff/asio.git"

  bottle do
    cellar :any
    sha256 "3f2c8ab0aadadda4d4707b834787d0c02841a31cec763b4c4d32ca3f859bd314" => :catalina
    sha256 "7be9a1e39bbd3fa59059fc9d8d98f7f43520da052cf245f195bbdd325ec1a8ec" => :mojave
    sha256 "ea18bc6cca19d15ff019a98be7a9c31c34e477b5daac54ce7379f02a6635247f" => :high_sierra
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
