class Libmicrohttpd < Formula
  desc "Light HTTP/1.1 server library"
  homepage "https://www.gnu.org/software/libmicrohttpd/"
  url "https://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-0.9.53.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.53.tar.gz"
  sha256 "9b15ec2d381f44936323adfd4f989fa35add517cccbbfa581896b02a393c2cc4"

  bottle do
    cellar :any
    sha256 "44580fceb6477e2f4fb6a4d4659a48b41c5b5b8bf6477a1679467830dfa0324b" => :sierra
    sha256 "ed10cf7c59d160631d12c558e6debaa0c31a4cef7946a479af95d6be076f8a6c" => :el_capitan
    sha256 "0cbd499c1d9e7126dddfcad9817ac442904c3fdde416c3c3b9f545566d6be58c" => :yosemite
  end

  option "with-ssl", "Enable SSL support"

  if build.with? "ssl"
    depends_on "libgcrypt"
    depends_on "gnutls"
  end

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
