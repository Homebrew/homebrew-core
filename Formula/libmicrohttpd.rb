class Libmicrohttpd < Formula
  desc "Light HTTP/1.1 server library"
  homepage "https://www.gnu.org/software/libmicrohttpd/"
  url "http://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-0.9.47.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.47.tar.gz"
  sha256 "96bdab4352a09fd3952a346bc01898536992f50127d0adea1c3096a8ec9f658c"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha256 "658b30965728ec52454a70fc3bdd032fc3d995e77966e02821ffea0eba170896" => :el_capitan
    sha256 "b94ebccf25a21c4bdeedd0d1a227601142231210d4182a38897a04c89356c8e7" => :yosemite
    sha256 "50ead40afe7f5144004abfd5769de833313de841e3499495fe164190fc78cc26" => :mavericks
  end

  option "with-ssl", "Enable SSL support"
  option :universal

  if build.with? "ssl"
    depends_on "libgcrypt"
    depends_on "gnutls"
  end

  def install
    ENV.universal_binary if build.universal?
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
