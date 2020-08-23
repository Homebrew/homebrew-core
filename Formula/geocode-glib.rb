class GeocodeGlib < Formula
  desc "GNOME library for gecoding and reverse geocoding"
  homepage "https://developer.gnome.org/geocode-glib"
  url "https://download.gnome.org/sources/geocode-glib/3.26/geocode-glib-3.26.2.tar.xz"
  sha256 "01fe84cfa0be50c6e401147a2bc5e2f1574326e2293b55c69879be3e82030fd1"
  revision 1

  bottle do
    cellar :any
    sha256 "52ce343c52ad20417f87bde9889b0086768b657874d94fd39eb54141f20fcedd" => :catalina
    sha256 "e7d30594593bc5fcc430f548d304ec88ff053ab5eebcd6f4bd696fd8b0c4acc7" => :mojave
    sha256 "74d7d13e5d99f9d4f07674faa262d68b57d86b550e0504dbf0797e84de9e52fa" => :high_sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+3"
  depends_on "json-glib"
  depends_on "libsoup"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Denable-installed-tests=false", "-Denable-gtk-doc=false", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  def post_install
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/gnome"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <geocode-glib/geocode-glib.h>

      int main(int argc, char *argv[]) {
        GeocodeLocation *loc = geocode_location_new(1.0, 1.0, 1.0);
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/geocode-glib-1.0
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lgeocode-glib
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lintl
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
