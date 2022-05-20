class Asio < Formula
  desc "Cross-platform C++ Library for asynchronous programming"
  homepage "https://think-async.com/Asio"
  url "https://downloads.sourceforge.net/project/asio/asio/1.22.1%20%28Stable%29/asio-1.22.1.tar.bz2"
  sha256 "6874d81a863d800ee53456b1cafcdd1abf38bbbf54ecf295056b053c0d7115ce"
  license "BSL-1.0"
  head "https://github.com/chriskohlhoff/asio.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?Stable.*?/asio[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b3ea7931fb9e539f59bbf21f4647268487036aace40cda956d08507fe87bb90b"
    sha256 cellar: :any,                 arm64_big_sur:  "5a8c945335115a2da264ec74162e57a5d92f4064544899c4df375a3cabc5e06a"
    sha256 cellar: :any,                 monterey:       "98f1add58eeb5d6eb9d886781ef62dd0b6572dd8252252acdaa2bc1d3674c875"
    sha256 cellar: :any,                 big_sur:        "dc03f2f6433eadeb86832d94a241c36a5be0eb23afde03644a11a62403a9b795"
    sha256 cellar: :any,                 catalina:       "7c8ae5863a8abf20d8d811ec943c8bff0e702b7dc4e79ebbab9310bcc7a99e44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "723acb5f60519bdc4426ac9d6e4e5689f94c794b615b6f71759d26eda1385df1"
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
