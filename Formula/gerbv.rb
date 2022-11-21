class Gerbv < Formula
  desc "Gerber (RS-274X) viewer"
  homepage "https://gerbv.github.io/"
  url "https://github.com/gerbv/gerbv/archive/refs/tags/v2.9.5.tar.gz"
  sha256 "a90b3e50941bed90eaf45e9b0d19b2d074eec1f433dcf3a1b3cbf14d8dc7c1ec"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "c078f973a81f5ca0c840cabe5d84bca8046a38e2bdd32cda2ef8bc49c24cd1e5"
    sha256 arm64_monterey: "950b0b1ca9d3eeba0969942d3dae2cbec4763486d019487722cc499dafc1ca26"
    sha256 arm64_big_sur:  "8b33c2b141d62e56e7f1614338b869d0f7c5c6e9b7f0d82402377f4303436b53"
    sha256 ventura:        "722f3d5a190b233a91710c4c4a3e856423f56ff80031b9e8c79d0c62f7530f88"
    sha256 monterey:       "7adea609399112bf9ac696eb8e5d1f6f6fda7074d6f2c4e24fbe25d613301f0a"
    sha256 big_sur:        "95788334f0a71a78241df7e808e4563a1d8a13d9a4e0865b5369726064788fca"
    sha256 catalina:       "09d4f39eee02503e116457a291a7252bde5da85e2951a29bae23533187a3ee88"
    sha256 x86_64_linux:   "be57eadae3680d2486074e14762b15c3ed5473a066994b2e069662be676f0001"
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
