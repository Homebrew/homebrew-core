class Gtksourceview < Formula
  desc "Text view with syntax, undo/redo, and text marks"
  homepage "https://projects.gnome.org/gtksourceview/"
  url "https://download.gnome.org/sources/gtksourceview/2.10/gtksourceview-2.10.5.tar.gz"
  sha256 "f5c3dda83d69c8746da78c1434585169dd8de1eecf2a6bcdda0d9925bf857c97"
  revision 7

  bottle do
    sha256 arm64_sonoma:   "eb0553b93b8b0e505d18bbd52bb38418d63c983ea3a9b659c6672796c04972a1"
    sha256 arm64_ventura:  "72c810e4c8bec98a46a3cb998149c1f5866818b1bfdfc18ed895cfae3eb07da0"
    sha256 arm64_monterey: "4751be60ebb27600b1c3e3a5cc1130a8b30fd0c560ccbc9b869c57a41136b894"
    sha256 arm64_big_sur:  "95cfffbde61e36b9212d7f4d0caa87f523567888d2f2a6304b1a17e67d26338d"
    sha256 sonoma:         "bbb1d79f8e083d650711d273bb3cb342e17f780e17acbf1cccde1f14d7a0c5a2"
    sha256 ventura:        "c8b1bfcf2f675036284557c4bdaaff0916fa07cb09126893fb7b719120e10476"
    sha256 monterey:       "08668cd19c9c124cc636678f0503dbfe80afb61d42d9113fdd681c74eecb73ef"
    sha256 big_sur:        "a64b1b82ecad5a2c291245237e253ee85f1c6887726b97380e60be733459db1d"
    sha256 x86_64_linux:   "138535f8db7f04bd9beb9d9dea5762b006b0425662d93397fad10cd88647d0f7"
  end

  # GTK 2 is EOL: https://blog.gtk.org/2020/12/16/gtk-4-0/
  disable! date: "2024-01-21", because: :unmaintained

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gtk+"

  uses_from_macos "perl" => :build

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

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
      ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].libexec/"lib/perl5"
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
