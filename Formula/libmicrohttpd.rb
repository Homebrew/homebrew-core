class Libmicrohttpd < Formula
  desc "Light HTTP/1.1 server library"
  homepage "https://www.gnu.org/software/libmicrohttpd/"
  url "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.62.tar.gz"
  mirror "https://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-0.9.62.tar.gz"
  sha256 "bd3e097d703f5091a6a01b56c0464a90fdd17f5d50478cea50a346b25c88db49"
  revision 1

  bottle do
    cellar :any
    sha256 "e2a6d6aba4b8a259cafd558e58d7424e1b2ddbd2afbc6b98bbc2ef3617971cd2" => :mojave
    sha256 "d76e6ca726c0067832ee7ca266bb856b8b6a9065c6e94910fbd6aeb1428478c8" => :high_sierra
    sha256 "9085e50cae90cfd889f001092af2ed63f26078b9f9683b945a281f00b5fd9317" => :sierra
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
