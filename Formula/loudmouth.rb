class Loudmouth < Formula
  desc "Lightweight C library for the Jabber protocol"
  homepage "https://mcabber.com"
  url "https://mcabber.com/files/loudmouth/loudmouth-1.5.3.tar.bz2"
  sha256 "54329415cb1bacb783c20f5f1f975de4fc460165d0d8a1e3b789367b5f69d32c"
  revision 1

  bottle do
    cellar :any
    sha256 "b361c56b41bf7248fa3b12893856ef54bb3b06f895c2667ffc51c83a5ce44bff" => :mojave
    sha256 "0ae2fce2fd5edcea19ecf80cbcc4f12ab203e92f85c8c28f9444f11fc34df37c" => :high_sierra
    sha256 "778b6156e5d99748a1e4a2e45683cdea3c08295ad6dbaccf64cd23eea0f952ed" => :sierra
    sha256 "92264a248d2b8b7c02e4ab60cd64430869fac7ce5a09a49154c6b2ed3659223a" => :el_capitan
  end

  head do
    url "https://github.com/mcabber/loudmouth.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "libidn"

  def install
    system "./autogen.sh", "-n" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-ssl=gnutls"
    system "make"
    system "make", "check"
    system "make", "install"
    (pkgshare/"examples").install Dir["examples/*.c"]
  end

  test do
    cp pkgshare/"examples/lm-send-async.c", testpath
    system ENV.cc, "lm-send-async.c", "-o", "test",
      "-L#{lib}", "-L#{Formula["glib"].opt_lib}", "-lloudmouth-1", "-lglib-2.0",
      "-I#{include}/loudmouth-1.0",
      "-I#{Formula["glib"].opt_include}/glib-2.0",
      "-I#{Formula["glib"].opt_lib}/glib-2.0/include"
    system "./test", "--help"
  end
end
