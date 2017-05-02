class Libmicrohttpd < Formula
  desc "Light HTTP/1.1 server library"
  homepage "https://www.gnu.org/software/libmicrohttpd/"
  url "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.54.tar.gz"
  mirror "https://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-0.9.54.tar.gz"
  sha256 "bcc721895d4a114b0548a39d2241c35caacb9e2e072d40e11b55c60e3d5ddcbe"

  bottle do
    cellar :any
    sha256 "7154e2f62155293ceeeb8ad059747e9e63d3ede14883fa95e4f0a509947ccf7c" => :sierra
    sha256 "ad773ae2fb74c77a33d76bb5f5dc6c25e65ce4bb3ae9c1d52488ec00de54a63d" => :el_capitan
    sha256 "e690c0741c566325dcf63ae6265bc1bad010992dc61e0acb824573dc3d5d3f63" => :yosemite
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
