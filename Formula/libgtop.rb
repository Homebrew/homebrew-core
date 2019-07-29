class Libgtop < Formula
  desc "Library for portably obtaining information about processes"
  homepage "https://library.gnome.org/devel/libgtop/stable/"
  url "https://download.gnome.org/sources/libgtop/2.40/libgtop-2.40.0.tar.xz"
  sha256 "78f3274c0c79c434c03655c1b35edf7b95ec0421430897fb1345a98a265ed2d4"
  revision 1

  bottle do
    sha256 "207550dec06c9af31f523534a6ca65906b7e4c69ad6ec670969f98e00dcc8c2b" => :mojave
    sha256 "981a91a3221651bf94e922f8e29cd8be08527453a833ab8f69cb7dbf7d39ed0d" => :high_sierra
    sha256 "77db9c002217605f8bad346413fc8cc038109ddd65ba7e62e09d25d341e1023f" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-x"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <glibtop/sysinfo.h>

      int main(int argc, char *argv[]) {
        const glibtop_sysinfo *info = glibtop_get_sysinfo();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/libgtop-2.0
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lglib-2.0
      -lgtop-2.0
      -lintl
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
