class Libmicrohttpd < Formula
  desc "Light HTTP/1.1 server library"
  homepage "https://www.gnu.org/software/libmicrohttpd/"
  url "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.54.tar.gz"
  mirror "https://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-0.9.54.tar.gz"
  sha256 "bcc721895d4a114b0548a39d2241c35caacb9e2e072d40e11b55c60e3d5ddcbe"

  bottle do
    cellar :any
    sha256 "a52261bd25dd6df623d0a2eaf47211891d5d3f51552a9aa3a05000b5121514fa" => :sierra
    sha256 "af07ea54d8c3a8329340f56a15c72deb7f3d960ab2bf83796566181386b802c5" => :el_capitan
    sha256 "c0b49ae254ea957f29e649d1e57a2460850da97b98477ea3aa3b76b74c1d98eb" => :yosemite
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
