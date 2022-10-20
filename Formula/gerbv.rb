class Gerbv < Formula
  desc "Gerber (RS-274X) viewer"
  homepage "https://gerbv.github.io/"
  url "https://github.com/gerbv/gerbv/archive/refs/tags/v2.9.3.tar.gz"
  sha256 "093a44e44b2fb39a76c8072d0c7395f0eb0a4ae724e4ea79dc74b87c363922e2"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "1dc17ba327872c4aba715e6176b42bc982e63722907c9788bef53b8e9a168532"
    sha256 arm64_big_sur:  "97a59cfe9a95e03cd4e005c9cc27149a87fba23108825b72395454db52ef1eea"
    sha256 monterey:       "75aead9b7eb09a0c62870e143966d2fcb18cebf982efd9fc3dfe0242f76964ec"
    sha256 big_sur:        "f7df131b3bffed396035f9e58d83ef46feca122771750cddad9d71830d3fd7c8"
    sha256 catalina:       "4bd7cd15a790a21cdb842ebefce89de86ea0ba1c81389b45812db96ea91e797a"
    sha256 x86_64_linux:   "c3937c334f43de103e8cf9a97714178ba3c0f227209d2ae11d0e0e2b657a1c8d"
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
