class Gedit < Formula
  desc "GNOME text editor"
  homepage "https://gedit-technology.github.io/apps/gedit/"
  url "https://gitlab.gnome.org/World/gedit/gedit/-/archive/50.0/gedit-50.0.tar.bz2"
  sha256 "c2d064001b95196f046a6f9705245e3a02dc427265f4e24af9bd2d5f3cb619ee"
  license "GPL-2.0-or-later"
  revision 2
  head "https://gitlab.gnome.org/World/gedit/gedit.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "fe10240fa0bdb15052bd461c290ce73714de7f23cda543fb2e96bd4ce1775341"
    sha256 arm64_sequoia: "67d0b8286d28daecbf600a82a9de3d345a25026703f1e2596fbf09d0e3b0d3ab"
    sha256 arm64_sonoma:  "cdb11eff0b46607f810c9317a3a148bd1e27dd8de36af513127fec408417fca4"
    sha256 sonoma:        "a18b5a3cdff4ebda4c1b01212b972b39ced2927a5ea66084c05067c9f3213cf8"
    sha256 arm64_linux:   "30eb60d1434a171ee0d8d9be4d7fac80636228412d2c624fda1e08a81a6c29f3"
    sha256 x86_64_linux:  "b9f5d5e202aafb0690e961b1a5c5a65f5738cf7e1ec26ae21cc78f52d3952bd1"
  end

  depends_on "desktop-file-utils" => :build # for update-desktop-database
  depends_on "docbook-xsl" => :build
  depends_on "gettext" => :build
  depends_on "gtk-doc" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gsettings-desktop-schemas"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "libgedit-amtk"
  depends_on "libgedit-gfls"
  depends_on "libgedit-gtksourceview"
  depends_on "libgedit-tepl"
  depends_on "libpeas@1"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
    depends_on "gtk-mac-integration"
  end

  resource "libgd" do
    url "https://gitlab.gnome.org/GNOME/libgd/-/archive/c7c7ff4e05d3fe82854219091cf116cce6b19de0.tar.bz2"
    version "c7c7ff4e05d3fe82854219091cf116cce6b19de0"
    sha256 "343abb090461d011dfb1bce5b5da1dfbc9f6c7b6b3223a1b322adb33675212c1"

    livecheck do
      url "https://gitlab.gnome.org/api/v4/projects/World%2Fgedit%2Fgedit/repository/files/subprojects%2Flibgd?ref=#{LATEST_VERSION}"
      strategy :json do |json|
        json["blob_id"]
      end
    end
  end

  def install
    resource("libgd").stage buildpath/"subprojects/libgd"

    ENV["DESTDIR"] = "/"
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    ENV.append_to_cflags "-Wno-implicit-function-declaration"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}/gedit" if OS.linux?

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system formula_opt_bin("glib")/"glib-compile-schemas", HOMEBREW_PREFIX/"share/glib-2.0/schemas"
    system formula_opt_bin("gtk+3")/"gtk3-update-icon-cache", "-qtf", HOMEBREW_PREFIX/"share/icons/hicolor"
  end

  test do
    ENV.prepend_path "PKG_CONFIG_PATH", formula_opt_lib("icu4c")/"pkgconfig" if OS.mac?
    ENV.prepend_path "PKG_CONFIG_PATH", formula_opt_lib("libpeas@1")/"pkgconfig"

    # main executable test
    system bin/"gedit", "--version"
    # API test
    (testpath/"test.c").write <<~C
      #include <gedit/gedit-debug.h>

      int main(int argc, char *argv[]) {
        gedit_debug_init();
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs gedit").chomp.split
    flags << "-Wl,-rpath,#{lib}/gedit" if OS.linux?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
