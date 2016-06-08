class Loudmouth < Formula
  desc "Lightweight C library for the Jabber protocol"
  homepage "https://mcabber.com"
  url "https://mcabber.com/files/loudmouth/loudmouth-1.5.3.tar.bz2"
  sha256 "54329415cb1bacb783c20f5f1f975de4fc460165d0d8a1e3b789367b5f69d32c"

  bottle do
    cellar :any
    sha256 "b1cc2d6af15d37cb3317a52d8a82422cd071c3ae4efe93353f75cdba83a20723" => :el_capitan
    sha256 "1f5d182146487152aa2b20b7cf998b1ed57da9f0c5f9830fb2a316afcbaa48f7" => :yosemite
    sha256 "50967fd422f40a3b911205cb4dfdac27038120c1e860646621dc7343f07c231b" => :mavericks
  end

  head do
    url "https://github.com/mcabber/loudmouth.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libidn"
  depends_on "gnutls"
  depends_on "gettext"

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
      "-lloudmouth-1", "-lglib-2.0",
      "-I#{include}/loudmouth-1.0",
      "-I#{Formula["glib"].opt_include}/glib-2.0",
      "-I#{Formula["glib"].opt_lib}/glib-2.0/include"
    system "./test", "--help"
  end
end
