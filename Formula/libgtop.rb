class Libgtop < Formula
  desc "Library for portably obtaining information about processes"
  homepage "https://library.gnome.org/devel/libgtop/stable/"
  url "https://download.gnome.org/sources/libgtop/2.34/libgtop-2.34.0.tar.xz"
  sha256 "8d8ae39e700d1c8c0b3e1391ed10ca88e6fc14f49d175d516dab6e3313b4ee2a"

  bottle do
    sha256 "1b6dd8bba18db9ebed44b58bbf99e3b94d207be8e3c120a40d2a44d15d2a5a50" => :sierra
    sha256 "9b8ceeb264abb5c07af3a72bcefa52c2b1adb4fc653fce58e08781e07f4a6345" => :el_capitan
    sha256 "19d041da8eb252e9b96445bdbd90bceaaa9433006c54bfb19ee1aed9f4699007" => :yosemite
    sha256 "31cc9651d4ecfb271a6186218e0b3c208321d76bf81d3d60f63d514794dcabb1" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gobject-introspection"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-x"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
