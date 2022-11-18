class Gedit < Formula
  desc "GNOME text editor"
  homepage "https://wiki.gnome.org/Apps/Gedit"
  url "https://download.gnome.org/sources/gedit/42/gedit-42.2.tar.xz"
  sha256 "3c6229111f0ac066ae44964920791d1265f5bbb56b0bd949a69b7b1261fc8fca"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "c253e30e47bbcc7e6b972264d6f6334365437b88a959be5af553db4744aa1bb9"
    sha256 arm64_monterey: "349a305bae4108e2579712280ceb0e884d0e377969b2c22e0cee37a188a745b6"
    sha256 arm64_big_sur:  "98dbef10f7bbe8133b08a73b958b286e0f73cd1bd265d09eb7365fe66d84b1b7"
    sha256 ventura:        "9408abb8470b821723b5c54c365c44ba63c754defbc5a1fe8a30cf975ee2f63d"
    sha256 monterey:       "60e99ade2028f2f87bc7c1337e23467262c7368e1cb14e84312249c9b22b8399"
    sha256 big_sur:        "8e0ad599fa98901f11027ba6e9316f92fe775772589d08f99c900b2caa1d1d7b"
    sha256 catalina:       "710be60f7b9559237bc7e6a3ec47fe0e1b502440298881786ce18482daa734c3"
    sha256 x86_64_linux:   "a88a052db3e1337e2f5264f192a284ab29b0332f9235beae9aefc02244ec18eb"
  end

  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build
  depends_on "adwaita-icon-theme"
  depends_on "atk"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gsettings-desktop-schemas"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "gtksourceview4"
  depends_on "libpeas"
  depends_on "libsoup"
  depends_on "libxml2"
  depends_on "pango"

  def install
    ENV["DESTDIR"] = "/"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}/gedit" if OS.linux?

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system Formula["glib"].opt_bin/"glib-compile-schemas", HOMEBREW_PREFIX/"share/glib-2.0/schemas"
    system Formula["gtk+3"].opt_bin/"gtk3-update-icon-cache", "-qtf", HOMEBREW_PREFIX/"share/icons/hicolor"
  end

  test do
    # Remove when `jpeg-turbo` is no longer keg-only.
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["jpeg-turbo"].opt_lib/"pkgconfig"

    # main executable test
    system bin/"gedit", "--version"
    # API test
    (testpath/"test.c").write <<~EOS
      #include <gedit/gedit-debug.h>

      int main(int argc, char *argv[]) {
        gedit_debug_init();
        return 0;
      }
    EOS
    flags = shell_output("pkg-config --cflags --libs gedit").chomp.split
    flags << "-Wl,-rpath,#{lib}/gedit" if OS.linux?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
