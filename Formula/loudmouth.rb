class Loudmouth < Formula
  desc "Lightweight C library for the Jabber protocol"
  homepage "https://mcabber.com"
  url "https://mcabber.com/files/loudmouth/loudmouth-1.5.3.tar.bz2"
  sha256 "54329415cb1bacb783c20f5f1f975de4fc460165d0d8a1e3b789367b5f69d32c"

  bottle do
    cellar :any
    sha256 "7496e86f5ebae132e5e3a8ff93edff5286c571325f17be7d3cac89e4215df1fb" => :sierra
    sha256 "53889a88701be6fe002a01116ec82318bef831da9612b9d18c80415a6ae04838" => :el_capitan
    sha256 "cbb202d52194ab9e27a7879fe82c0eec3704e27906b7765103370ae710bdbc88" => :yosemite
    sha256 "d6a2f38aa092c260e00ef7f370c8ceb826268ec59ace265e52788284b70402d8" => :mavericks
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
