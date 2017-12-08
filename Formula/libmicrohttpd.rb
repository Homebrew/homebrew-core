class Libmicrohttpd < Formula
  desc "Light HTTP/1.1 server library"
  homepage "https://www.gnu.org/software/libmicrohttpd/"
  url "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.58.tar.gz"
  mirror "https://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-0.9.58.tar.gz"
  sha256 "7a11e1376c62ff95bd6d2dfe6799d57ac7cdbcb32f70bfbd5e47c71f373e01f3"

  bottle do
    cellar :any
    sha256 "a7235a945870b368f0d00a4e5127a341b06f7aae918f684eb36085d02976134d" => :high_sierra
    sha256 "2d5c159bfca44baa79770c6482284d84340ac11730ec6301d913698e2b2321ed" => :sierra
    sha256 "4cc1dd3468dd6abd47c8cff012f69a25d63cc39851780cf6f20c9922fdc78dde" => :el_capitan
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
