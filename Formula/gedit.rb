class Gedit < Formula
  desc "GNOME text editor"
  homepage "https://wiki.gnome.org/Apps/Gedit"
  url "https://download.gnome.org/sources/gedit/42/gedit-42.1.tar.xz"
  sha256 "7f1fd43df5110d4c37de6541993f41f0fbc3efc790900e92053479ba069920e9"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "6bf62715f6d13766d9f5acecccb83388fd76e676717bf66fd35c1583f24cc52a"
    sha256 arm64_big_sur:  "befed484ace491f22c794ab58ab00c163926f3a371fbaef317aed9fce9777eb6"
    sha256 monterey:       "00937891d211cb9135396a1772b1455ea25b5456e95ccd3fb959d99b0463ee4f"
    sha256 big_sur:        "a8f006d3c869d4758f8c2807a689105148af330f9ee3261d0bbe07e9e70793ea"
    sha256 catalina:       "0b09d9d9db66e4c95211942e5b0bb8edd341ea40edb6ddb272876a1e72f3753b"
    sha256 x86_64_linux:   "799ad9372a0590ae0bb113949df29cd769207a46dc3378d83b6b03982f41d1c4"
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

    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  def post_install
    system Formula["glib"].opt_bin/"glib-compile-schemas", HOMEBREW_PREFIX/"share/glib-2.0/schemas"
    system Formula["gtk+3"].opt_bin/"gtk3-update-icon-cache", "-qtf", HOMEBREW_PREFIX/"share/icons/hicolor"
  end

  test do
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
