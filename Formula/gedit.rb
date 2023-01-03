class Gedit < Formula
  desc "GNOME text editor"
  homepage "https://wiki.gnome.org/Apps/Gedit"
  url "https://download.gnome.org/sources/gedit/44/gedit-44.0.tar.xz"
  sha256 "82e6b33d8957cc19e30dba10402585f98d2e25e76a9be97ead83418103074502"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "1bb028d9bbcc56cc07d279b40795eab449ab24764b18bafeb3d7c621335753cc"
    sha256 arm64_monterey: "b4a537748c49990c517a3e4c19d044bc05c0a0ba681d933bc40e779d8c0de68b"
    sha256 arm64_big_sur:  "97efe6c58217625bedb4b23585dee2f96da1ae71f29a387303311d692ebb6855"
    sha256 ventura:        "6b250c2f6e133e5b5fd887668e6d8be679caa2c4bf2f6a99094f8d947a95f974"
    sha256 monterey:       "ad78103ace562783d786121f186b4ce2826fc81141b72de4d8cd9edfdbfb72da"
    sha256 big_sur:        "a0f91aa14cccf6cb202f137145a2e5061f19956406ba567071201b91a9ae26d5"
    sha256 x86_64_linux:   "48f25b52bd295e577616313f9847441b212c1b3c4583274dc452d99692dc3ff7"
  end

  depends_on "docbook-xsl" => :build
  depends_on "gtk-doc" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build
  depends_on "adwaita-icon-theme"
  depends_on "amtk"
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
  depends_on "tepl"

  # Fix for macOS build failure
  # Remove in next release
  patch do
    url "https://gitlab.gnome.org/GNOME/gedit/-/commit/b648d64c1492c187000e92377a390e65d7ddadf5.diff"
    sha256 "672f75fe5788534ebf9092fd7506913afa5631710084b0efd232a036ef16c3b5"
  end

  def install
    ENV["DESTDIR"] = "/"
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
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
