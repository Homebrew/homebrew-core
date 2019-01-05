class Libmicrohttpd < Formula
  desc "Light HTTP/1.1 server library"
  homepage "https://www.gnu.org/software/libmicrohttpd/"
  url "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.62.tar.gz"
  mirror "https://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-0.9.62.tar.gz"
  sha256 "bd3e097d703f5091a6a01b56c0464a90fdd17f5d50478cea50a346b25c88db49"
  revision 1

  bottle do
    cellar :any
    sha256 "80aa9fa5bb61720c650e1beaa633c6061279c444ca0fc122392cb4d5de9f1b71" => :mojave
    sha256 "f92b7fecd9a82f3f3a3ef80f878ad1114995b47a20e9b7fe0b1df8372427c331" => :high_sierra
    sha256 "e98e530fc45a8b3db33798216c4c30c151083320522a817fab3984790a82a5e5" => :sierra
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
