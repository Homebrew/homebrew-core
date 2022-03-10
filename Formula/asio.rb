class Asio < Formula
  desc "Cross-platform C++ Library for asynchronous programming"
  homepage "https://think-async.com/Asio"
  url "https://downloads.sourceforge.net/project/asio/asio/1.22.0%20%28Stable%29/asio-1.22.0.tar.bz2"
  sha256 "1e0737d43fa192938c77c16d80809e5b40630549de44d649a1371a07c39d4550"
  license "BSL-1.0"
  head "https://github.com/chriskohlhoff/asio.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?Stable.*?/asio[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bb9bc380f31b310a58903d3279f8063bf43b8d01fcc0b017b7d27038cdff73cb"
    sha256 cellar: :any,                 arm64_big_sur:  "f0c0a759b985698ae75f3518f6433709ec35e049b8dd31f6214d6f558a1866be"
    sha256 cellar: :any,                 monterey:       "f0087aa5a0c0d1abc32f7012a83b5e1e20a8821d9dd64902982d6ef676571feb"
    sha256 cellar: :any,                 big_sur:        "b9c4dcfc70f7f67ad60386c29c99295ebf1e175a9388983dd229cf5e0045678e"
    sha256 cellar: :any,                 catalina:       "75f5d5616511210eb6e208b72c6676998c5354bb08751207f494cb9c4225a674"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a855ff871ff92b07db6dc50b667b0e97caa9f31f1963f6b1761d8dd9f8ec14a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "openssl@1.1"

  # Tarball is missing `src/examples/cpp20`, which causes error:
  # config.status: error: cannot find input file: `src/examples/cpp20/Makefile.in'
  # TODO: Remove in the next release
  patch :DATA

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
      assert_match "404 Not Found", shell_output("curl http://127.0.0.1:#{port}")
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index 56365c2..84045ba 100644
--- a/configure.ac
+++ b/configure.ac
@@ -241,4 +241,4 @@ AC_OUTPUT([
   src/examples/cpp11/Makefile
   src/examples/cpp14/Makefile
   src/examples/cpp17/Makefile
-  src/examples/cpp20/Makefile])
+])
