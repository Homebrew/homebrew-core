class GtkMacIntegration < Formula
  desc "Integrates GTK macOS applications with the Mac desktop"
  homepage "https://wiki.gnome.org/Projects/GTK+/OSX/Integration"

  stable do
    url "https://download.gnome.org/sources/gtk-mac-integration/2.1/gtk-mac-integration-2.1.2.tar.xz"
    sha256 "68e682a3ba952e7d4b1cfa2c7147c5fcd76f8bd9792a567e175a619af5954af1"

    patch do
      url "https://github.com/jralls/gtk-mac-integration/pull/11.patch?full_index=1"
      sha256 "4523207ea652b9048d01a58c05369c871def4e187db267ab7bad85ae1e102c31"
    end

    patch do
      url "https://github.com/jralls/gtk-mac-integration/pull/13.patch?full_index=1"
      sha256 "b0ecfb9a3c5cd9651584b33191b69915627cc9e09e78fb4623fcaa64915ee13d"
    end
  end

  bottle do
    rebuild 1
    sha256 "ec24d3b0e4c0509dcae72e6d6b9a55d1045de25ecd45d923d0d2744e0775010f" => :high_sierra
    sha256 "a81bce6683ec07ebe6acf464f5dabf417681ea5785194bf69f1614cef2353c2c" => :sierra
    sha256 "1be8f19849300cb593fd454d4407620c25fbb04ca4f4d7dc0e16261b1d26e04e" => :el_capitan
  end

  head do
    url "https://github.com/jralls/gtk-mac-integration.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gtk+"
  depends_on "gtk+3" => :recommended
  depends_on "pygtk"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-gtk2
      --enable-python=yes
      --enable-introspection=yes
    ]

    args << (build.without?("gtk+3") ? "--without-gtk3" : "--with-gtk3")
    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gtkosxapplication.h>

      int main(int argc, char *argv[]) {
        gchar *bundle = gtkosx_application_get_bundle_path();
        return 0;
      }
    EOS
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gtkx = Formula["gtk+"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gtkx.opt_include}/gtk-2.0
      -I#{gtkx.opt_lib}/gtk-2.0/include
      -I#{include}/gtkmacintegration
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -DMAC_INTEGRATION
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gtkx.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lgdk-quartz-2.0
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lgtk-quartz-2.0
      -lgtkmacintegration-gtk2
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
