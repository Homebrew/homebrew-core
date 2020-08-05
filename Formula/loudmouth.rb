class Loudmouth < Formula
  desc "Lightweight C library for the Jabber protocol"
  homepage "https://mcabber.com"
  url "https://mcabber.com/files/loudmouth/loudmouth-1.5.3.tar.bz2"
  sha256 "54329415cb1bacb783c20f5f1f975de4fc460165d0d8a1e3b789367b5f69d32c"
  revision 2

  bottle do
    cellar :any
    sha256 "88dfcc04d5dec8056ce00c91d881a31b01044f5eb4084da599df451b5a700471" => :catalina
    sha256 "43052aa18cefe00338ba03fe866badd2b2f17cb6766ae2a1203bdcd54cf2ca6b" => :mojave
    sha256 "28635ff511d03492181d4b2c9f4cfe5b65600f512bc4ed8dc02611ff1c4b1b56" => :high_sierra
    sha256 "72854a1ff4e2492f0b90d1f435c523ae3801e1ea60d65e033909043081004db0" => :sierra
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
