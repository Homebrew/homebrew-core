class Gedit < Formula
  desc "GNOME text editor"
  homepage "https://wiki.gnome.org/Apps/Gedit"
  url "https://download.gnome.org/sources/gedit/42/gedit-42.0.tar.xz"
  sha256 "a87991f42961eb4f6abcdbaabb784760c23aeaeefae6363d3e21a61e9c458437"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "742ecff3107cae13ab538fba653fbdb4e8290325269d5b105731a161513f4430"
    sha256 arm64_big_sur:  "1ea1042d4a49639ac76fe90382af0a1d8c5ec660ed4d4355b7c6b0d379fb3d28"
    sha256 monterey:       "5ff599ceb42be1e20f92783f6508aca717f7a6267386c8c17e9bcef21889b438"
    sha256 big_sur:        "c744068a0ba46c7a8fd85f4b3678b358625383cfcf4df058665f92de5c2c84d4"
    sha256 catalina:       "f08082b19703213a84e42a5d7e70bfcd61305c03d4a276fb35095044c5f839d5"
    sha256 x86_64_linux:   "1c9d10dcef030f49dad3dc5f23579b99d809a1258a93861f9cec445dbb0f0fbc"
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
