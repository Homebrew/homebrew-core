class Gedit < Formula
  desc "GNOME text editor"
  homepage "https://gedit-technology.github.io/apps/gedit/"
  url "https://gitlab.gnome.org/World/gedit/gedit/-/archive/49.0/gedit-49.0.tar.bz2"
  sha256 "f3437a675790c8593d511355252d751ab94328357bc6846d1106bf288161a5ed"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "f16f039fa3d91301dbdffbb90fe7a7e516298ca030f1d599ab9869bea105987a"
    sha256 arm64_sequoia: "a455eb1e0da6e1c6b453e53e1643c3f31a080d60870216c8c4ad7d62d69c386c"
    sha256 arm64_sonoma:  "16afa1324bafcb923f6d8f0fec2cf8878d631c109ef24173fedb5aa43db65ff5"
    sha256 sonoma:        "cc0e19ab35a92f1160e2d307422f9a78720cc851f0c1c74bc7e0a075a5702c02"
    sha256 arm64_linux:   "a7180250047f87965dcdac66475a5818f8ce37f8eafa3d82ecbbf924ed10fa11"
    sha256 x86_64_linux:  "77b6f806c5a7cfba5bdff000085f51c165fe6bfa64bece69054703030de7e7e6"
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
    url "https://gitlab.gnome.org/GNOME/libgd.git",
      revision: "3cccf99234288a6121b3945a25cd4ec3b7445c74"
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
    system Formula["glib"].opt_bin/"glib-compile-schemas", HOMEBREW_PREFIX/"share/glib-2.0/schemas"
    system Formula["gtk+3"].opt_bin/"gtk3-update-icon-cache", "-qtf", HOMEBREW_PREFIX/"share/icons/hicolor"
  end

  test do
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["icu4c"].opt_lib/"pkgconfig" if OS.mac?
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libpeas@1"].opt_lib/"pkgconfig"

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
