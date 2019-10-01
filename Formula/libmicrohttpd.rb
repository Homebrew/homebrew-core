class Libmicrohttpd < Formula
  desc "Light HTTP/1.1 server library"
  homepage "https://www.gnu.org/software/libmicrohttpd/"
  url "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.63.tar.gz"
  mirror "https://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-0.9.63.tar.gz"
  sha256 "37c36f1be177f0e37ef181a645cd3baac1000bd322a01c2eff70f3cc8c91749c"

  bottle do
    cellar :any
    sha256 "0d9d914ee9491289a10f751dce3e57efc02544cd520ec647d939a1b58baa60ef" => :catalina
    sha256 "065c03c15e7cddac444a335ae9a4a581b9cb10f9ea4edbafab86cb9ec083ce49" => :mojave
    sha256 "2b022a903526ca0d939b8660fd1d9ca82877c29734b177bb865631a6fbf0e375" => :high_sierra
    sha256 "60a0909d2d0f9784060686b71c58afae980601141d19d20d62c78c451467245c" => :sierra
  end

  depends_on "gnutls"
  depends_on "libgcrypt"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install "doc/examples"
  end

  test do
    cp pkgshare/"examples/simplepost.c", testpath
    inreplace "simplepost.c",
      "return 0",
      "printf(\"daemon %p\", daemon) ; return 0"
    system ENV.cc, "-o", "foo", "simplepost.c", "-I#{include}", "-L#{lib}", "-lmicrohttpd"
    assert_match /daemon 0x[0-9a-f]+[1-9a-f]+/, pipe_output("./foo")
  end
end
