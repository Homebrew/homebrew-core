class GeocodeGlib < Formula
  desc "GNOME library for gecoding and reverse geocoding"
  homepage "https://developer.gnome.org/geocode-glib"
  url "https://download.gnome.org/sources/geocode-glib/3.26/geocode-glib-3.26.2.tar.xz"
  sha256 "01fe84cfa0be50c6e401147a2bc5e2f1574326e2293b55c69879be3e82030fd1"
  license "GPL-2.0-or-later"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "21cca31313c96d334bf20a5db535619d0114128474f2f38bb09e4bbf422b721d"
    sha256 cellar: :any,                 monterey:      "d25cc02e785d8f10bedca31db01bf00c1cf0f2553f8ab4cac8266ad02fc7ed9e"
    sha256 cellar: :any,                 big_sur:       "41432c280b4a1244a1a55466059170cd470d5e86fddf1cf3ca7bc4f5f7d14960"
    sha256 cellar: :any,                 catalina:      "a0bdd13a694d1f4ee94de206de6fc03ad01df82ce3ca7ea7850e274eb86772b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5087451ab0d29991b1760b263802a81a2497f5a157f40ac931570c2146de42a8"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+3"
  depends_on "json-glib"
  depends_on "libsoup@2"

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libsoup@2"].opt_lib/"pkgconfig"
    ENV.prepend_path "XDG_DATA_DIRS", Formula["libsoup@2"].opt_share
    ENV.prepend_path "XDG_DATA_DIRS", HOMEBREW_PREFIX/"share"

    mkdir "build" do
      system "meson", *std_meson_args, "-Denable-installed-tests=false", "-Denable-gtk-doc=false", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  def post_install
    system Formula["gtk+3"].opt_bin/"gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/gnome"
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
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
