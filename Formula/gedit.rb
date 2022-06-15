class Gedit < Formula
  desc "GNOME text editor"
  homepage "https://wiki.gnome.org/Apps/Gedit"
  url "https://download.gnome.org/sources/gedit/42/gedit-42.1.tar.xz"
  sha256 "7f1fd43df5110d4c37de6541993f41f0fbc3efc790900e92053479ba069920e9"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "e86676c92593d01d9b0d1c04ae138d8c9d0653f5f9e67e957328ec13bedd52cd"
    sha256 arm64_big_sur:  "d663b941cc3dd78c2d9c48cc4cbb98e9326245bf68f10f44c36e7d36300e8f95"
    sha256 monterey:       "ec72280a13bd5c78436afcd1c829774fd778f8956656ec3be93aa2bbc04108d7"
    sha256 big_sur:        "5e53509d003a7597561e0457510cd8fc12aa48458c4d1ca11d60b8197c941815"
    sha256 catalina:       "2f9741e8a1ccca51e097e52d81eed9b268a8081491739a267a89f968f11a870e"
    sha256 x86_64_linux:   "cf0e8b86045a61b1a67af714598b9bee08573b2d78634cc9c72fb0d458945ace"
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
