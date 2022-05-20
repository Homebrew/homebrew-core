class Gtkspell3 < Formula
  desc "Gtk widget for highlighting and replacing misspelled words"
  homepage "https://gtkspell.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/gtkspell/3.0.10/gtkspell3-3.0.10.tar.xz"
  sha256 "b040f63836b347eb344f5542443dc254621805072f7141d49c067ecb5a375732"
  license "GPL-2.0-or-later"
  revision 3

  bottle do
    sha256 arm64_monterey: "6ff42450ce311ad95784403d3961db1a80bbac3d6b65597ea7673e576fd366cd"
    sha256 arm64_big_sur:  "17e1dd6d234ee6ce072ab846cdccc3fb2f672f809b4e9a2af0d55d92600e66d7"
    sha256 monterey:       "730c7a14140f20a9c105d3865a596e3ab11a05b12ba4526cafb7220ee0dcf289"
    sha256 big_sur:        "a3ad550626760e585e9474fd8a548315f02b113bb2a0d823957e809d848da464"
    sha256 catalina:       "b3b9eff2b9b11085e6b16cf50165031ab7446cd78aa125afd358747a67419bd8"
    sha256 mojave:         "1d41a37ab6c27e572e59bf7a0aaf1f66cfbbe587fffb5e9fdcc2749c24be4b26"
    sha256 high_sierra:    "590fb3c9f5b1f978d385128db8c8aec91b0285a3dbead32bc19c127d9a35bb50"
    sha256 x86_64_linux:   "95f986b2cdfac1f2266cd069ecc8dfeeaf21f2a95bffa0f06eff82dfe48020b6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "enchant"
  depends_on "gtk+3"

  uses_from_macos "perl" => :build

  def install
    ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5" unless OS.mac?

    system "autoreconf", "-fi"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug",
                          "--enable-vala",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gtkspell/gtkspell.h>

      int main(int argc, char *argv[]) {
        GList *list = gtk_spell_checker_get_language_list();
        return 0;
      }
    EOS
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    enchant = Formula["enchant"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gtkx3 = Formula["gtk+3"]
    harfbuzz = Formula["harfbuzz"]
    libepoxy = Formula["libepoxy"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{enchant.opt_include}/enchant-2
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/gio-unix-2.0/
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gtkx3.opt_include}/gtk-3.0
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/gtkspell-3.0
      -I#{libepoxy.opt_include}
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{enchant.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gtkx3.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lcairo-gobject
      -lenchant-2
      -lgdk-3
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgmodule-2.0
      -lgobject-2.0
      -lgtk-3
      -lgtkspell3-3
      -lpango-1.0
      -lpangocairo-1.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
