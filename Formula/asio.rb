class Asio < Formula
  desc "Cross-platform C++ Library for asynchronous programming"
  homepage "https://think-async.com/Asio"
  url "https://downloads.sourceforge.net/project/asio/asio/1.12.2%20%28Stable%29/asio-1.12.2.tar.bz2"
  sha256 "4e27dcb37456ba707570334b91f4798721111ed67b69915685eac141895779aa"
  revision 1
  head "https://github.com/chriskohlhoff/asio.git"

  bottle do
    cellar :any
    sha256 "8b5d9bd61bbcab5bfb24399ac03c8be667b227cfb32671d9a6bc7c748f0ee1d9" => :catalina
    sha256 "552c0f07fa8a9d1a867d23d06c3ef197a24cb06c1943a3c6965ef0b34a87abbd" => :mojave
    sha256 "dd68dc384f46920aa4ec4ad189fd5683810f27558a3217c4ec2080ecc575919c" => :high_sierra
    sha256 "b564abe29a03a745d5c0c3033fb17b7d1031382147c8818bf6d0bb034480d996" => :sierra
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
