class Libpeas < Formula
  desc "GObject plugin library"
  homepage "https://developer.gnome.org/libpeas/stable/"
  url "https://download.gnome.org/sources/libpeas/1.20/libpeas-1.20.0.tar.xz"
  sha256 "f392fffe2dc00072a51bb2a1b274224a06bdc5f9c3b3c0ac4816909e9933d354"

  bottle do
    sha256 "9bad6478fc3a334a1446286375bc467b16d34bcf3e8c9c05f12208edf370e496" => :sierra
    sha256 "b8fafb1141cbce2ffbb09fdc56bb79b48a3106119046f366fb3e56181c43f04f" => :el_capitan
    sha256 "cbaaef5811b5f5417d491d360749901e98afdddc5f3b6db8f6d6a4a1b62fb7a1" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext" => :build
  depends_on "gnome-common" => :build
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gtk+3"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-gtk"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <libpeas/peas.h>

      int main(int argc, char *argv[]) {
        PeasObjectModule *mod = peas_object_module_new("test", "test", FALSE);
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gobject_introspection = Formula["gobject-introspection"]
    libffi = Formula["libffi"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gobject_introspection.opt_include}/gobject-introspection-1.0
      -I#{include}/libpeas-1.0
      -I#{libffi.opt_lib}/libffi-3.0.13/include
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gobject_introspection.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lgirepository-1.0
      -lglib-2.0
      -lgmodule-2.0
      -lgobject-2.0
      -lintl
      -lpeas-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
