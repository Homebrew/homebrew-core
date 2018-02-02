class Libmicrohttpd < Formula
  desc "Light HTTP/1.1 server library"
  homepage "https://www.gnu.org/software/libmicrohttpd/"
  url "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.59.tar.gz"
  mirror "https://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-0.9.59.tar.gz"
  sha256 "9b9ccd7d0b11b0e179f1f58dc2caa3e0c62c8609e1e1dc7dcaadf941b67d923c"

  bottle do
    cellar :any
    sha256 "c31728e83733daf3ff9539c3222cc463af7db9983b0cc7f7194954a98d1a5233" => :high_sierra
    sha256 "cb4b9985866c60d9c09772f70b447e27cf0aa09ac58d60b730aa8dedbf4776f0" => :sierra
    sha256 "fab27d85da74bc18cce0877b0f9692b147bb4cdfb1866f1bd3acae14ed873984" => :el_capitan
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
