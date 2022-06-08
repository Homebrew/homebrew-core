class Gerbv < Formula
  desc "Gerber (RS-274X) viewer"
  homepage "https://gerbv.github.io/"
  url "https://github.com/gerbv/gerbv/archive/refs/tags/v2.9.2.tar.gz"
  sha256 "bea49fc5aa861caf1c0050be008f9316f502d318cb33588ffe59eece4ddbfcea"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "dce1ff5cfda7627e7f55f0604796d7d10608c52a59fe14af5708b6ea2fc9ec20"
    sha256 arm64_big_sur:  "5a92283afc6d91a84636fecaa1cf0050cf1cdfefa2bc628343c5c6ad397cf126"
    sha256 monterey:       "114e8b72b67b1a20e18b39264fd6ab7ff886f9dd74f11e0c7d4b5383ccbdab96"
    sha256 big_sur:        "8cc153a0d7c870e63111c674383b19496ec9165e8cc22369a4186b982235fa4e"
    sha256 catalina:       "5a96c736a5b68990c183abffc3d9629b9597d6e3935874c8f126c194018a9d36"
    sha256 x86_64_linux:   "90f4b8d1f2b57e2e2f691f9ec25f4f4bd2fd828aa4c30e58dc7dc041e395ea2a"
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
