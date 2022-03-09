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
    sha256 cellar: :any,                 arm64_monterey: "55ef1bffa04528d8b719a1d4885a66dedb61417cf6ffb148bbf9cbb46f19c744"
    sha256 cellar: :any,                 arm64_big_sur:  "6ae63027103addf746fc975cf3b9e521b7ab590e4e1a7891e8e10b433533607e"
    sha256 cellar: :any,                 monterey:       "74df62b424d6eb41db252df523b3148e73e9d635aabf515434e3e93bec435967"
    sha256 cellar: :any,                 big_sur:        "685e304d5cbb0291585a2941c4bc521e3d60175e31ecfc91146d480a84f04325"
    sha256 cellar: :any,                 catalina:       "d98a3f8267b7e3971fb5c712324858aa02252c718b55dc7e842c31922ad72d1c"
    sha256 cellar: :any,                 mojave:         "ae04393a3164eff530766bf44aa2983534d3eb1115879b0a9f9c6e027b1b9fca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7011f43a03777135319c7e21f5a96e57b31ced599c41fbf07aba6c0c46871e4b"
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
