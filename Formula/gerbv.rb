class Gerbv < Formula
  desc "Gerber (RS-274X) viewer"
  homepage "https://gerbv.github.io/"
  url "https://github.com/gerbv/gerbv/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "bf0400cbd888fcffc5374d41f57a7c80ed859b603183d488da381c4ef8168e41"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "05b4ffa6b9b03d2a3eea8b023d3811ef475064f9cc9a44e74ed662cbda9d1641"
    sha256 arm64_big_sur:  "21724451644da04ad6afba97653f0d0278ccd4a785f1d2eb42872a8dc8ad7969"
    sha256 monterey:       "1f15b2d6696232a5febfa384d1dff8c88b94508542dcd937f28bdb456b4febe3"
    sha256 big_sur:        "c8615af357e3f346dcce909f3ae9b2bebadc842e79e2a07486850ba8d17b5fbf"
    sha256 catalina:       "0148a6bca1ae346cae72d8cd788b1131d20a173a2b07c0762f2024c801f6efc9"
    sha256 x86_64_linux:   "0f6dee2e88f91f24a6f2e5a81812794608f30fccc52e17864a13c9cb795b5e00"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+"

  def install
    ENV.append "CPPFLAGS", "-DQUARTZ" if OS.mac?
    inreplace "autogen.sh", "libtool", "glibtool"

    # Disable commit reference in include dir
    inreplace "utils/git-version-gen.sh" do |s|
      s.gsub! 'RELEASE_COMMIT=`"${GIT}" rev-parse HEAD`', "RELEASE_COMMIT=\"\""
      s.gsub! "${PREFIX}~", "${PREFIX}"
    end
    system "./autogen.sh"
    system "./configure", *std_configure_args,
                          "--disable-dependency-tracking",
                          "--disable-update-desktop-database",
                          "--disable-schemas-compile"
    system "make"
    system "make", "install"
  end

  test do
    # executable (GUI) test
    system "#{bin}/gerbv", "--version"
    # API test
    (testpath/"test.c").write <<~EOS
      #include <gerbv.h>

      int main(int argc, char *argv[]) {
        double d = gerbv_get_tool_diameter(2);
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
      -I#{include}/gerbv-#{version}
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
      -lgerbv
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lpango-1.0
      -lpangocairo-1.0
    ]
    if OS.mac?
      flags += %w[
        -lgdk-quartz-2.0
        -lgtk-quartz-2.0
        -lintl
      ]
    end
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
