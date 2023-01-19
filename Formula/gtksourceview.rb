class Gtksourceview < Formula
  desc "Text view with syntax, undo/redo, and text marks"
  homepage "https://projects.gnome.org/gtksourceview/"
  url "https://download.gnome.org/sources/gtksourceview/2.10/gtksourceview-2.10.5.tar.gz"
  sha256 "f5c3dda83d69c8746da78c1434585169dd8de1eecf2a6bcdda0d9925bf857c97"
  revision 7

  bottle do
    sha256 arm64_ventura:  "ee366f1b7a1605ab1fd1a3b5a74cd1b408f2080e1ed0124621542b4319be28cf"
    sha256 arm64_monterey: "d48d0e57a52b6daa8a36000c39ae377cd4067a6dd2b3895d17bb6719dac8867c"
    sha256 arm64_big_sur:  "3622986240ea216f4a404ea7e40d2099d94bc0f175bdb0ac0d8b242c29d81514"
    sha256 ventura:        "1c9f71f01efc5943119902c9e58afd214c41cfffdd046cdfc10865bc88aed495"
    sha256 monterey:       "1338c7b2359052b1ac5770afac61477898528766e3dff0fa489fdd00f132bd7e"
    sha256 big_sur:        "146b08e9b6c084de86ed9de2783f50b4c564826f102b0d917579ffa19b60ab94"
    sha256 catalina:       "633745bd26dcc7d96f3c102002a2cdfb1cb45ff2762a5c2c814d2af787b6a5c5"
    sha256 mojave:         "e4acd9c34e98b342eac330a7c7393b1199441474be6e3d7523c6b173e609febe"
    sha256 x86_64_linux:   "d37f90eecf7dbc89d89af0efa8fe6f78d8912dc77fd525dff5d3a181cff9e22e"
  end

  # GTK 2 is EOL: https://blog.gtk.org/2020/12/16/gtk-4-0/
  deprecate! date: "2023-01-18", because: :unmaintained

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gtk+"

  uses_from_macos "perl" => :build

  resource "gtk-mac-integration" do
    on_macos do
      url "https://download.gnome.org/sources/gtk-mac-integration/3.0/gtk-mac-integration-3.0.1.tar.xz"
      sha256 "f19e35bc4534963127bbe629b9b3ccb9677ef012fc7f8e97fd5e890873ceb22d"
    end
  end

  # patches added the ensure that gtk-mac-integration is supported properly instead
  # of the old released called ige-mac-integration.
  # These are already integrated upstream in their gnome-2-30 branch but a release of
  # this remains highly unlikely
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/gtksourceview/2.10.5.patch"
    sha256 "1c91cd534d73a0f9b0189da572296c5bd9f99e0bb0d3004a5e9cbd9f828edfaf"
  end

  def install
    if OS.mac?
      resource("gtk-mac-integration").stage do
        system "./configure", "--prefix=#{libexec}",
                              "--disable-dependency-tracking",
                              "--disable-silent-rules",
                              "--with-gtk2",
                              "--without-gtk3",
                              "--enable-introspection=no"
        system "make", "install"
      end
      ENV.prepend_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"
    else
      ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5"
    end

    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gtksourceview/gtksourceview.h>

      int main(int argc, char *argv[]) {
        GtkWidget *widget = gtk_source_view_new();
        return 0;
      }
    EOS
    ENV.libxml2
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gtkx = Formula["gtk+"]
    harfbuzz = Formula["harfbuzz"]
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
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/gtksourceview-2.0
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
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
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lgtksourceview-2.0
      -lpango-1.0
      -lpangocairo-1.0
    ]
    if OS.mac?
      flags += %w[
        -lintl
        -lgdk-quartz-2.0
        -lgtk-quartz-2.0
      ]
    end
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
