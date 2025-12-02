class Glade < Formula
  desc "RAD tool for the GTK+ and GNOME environment"
  homepage "https://glade.gnome.org/"
  url "https://download.gnome.org/sources/glade/3.40/glade-3.40.0.tar.xz"
  sha256 "31c9adaea849972ab9517b564e19ac19977ca97758b109edc3167008f53e3d9c"
  license "LGPL-2.1-or-later"
  revision 2

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "6e30fc8505be745532d54c6ca937ed9112bad06b28a779e635b2a7bd39eec811"
    sha256 arm64_sequoia: "5873f72c18a9e4ec5fb39e7463dec97632e1e529d676a36720f21cf9cb8ce890"
    sha256 arm64_sonoma:  "d029fb2f0d9a5180e2d9d0a39e2dfbe384ea4ce8fb5d6baef129453f7a0e3ff2"
    sha256 sonoma:        "14f49050a388f8e5c976c4f2650f2261d8436dc3a2946c025bfbb65b78cb29d4"
    sha256 arm64_linux:   "2231d718915f58f039ff8f8b64c2e925a1f4c69da14e0e89065a319e3de970e8"
    sha256 x86_64_linux:  "d74c163da2a0558dbbb9d167f3ecea4bbc9c653b4a1f6f3539dc99a92452e624"
  end

  depends_on "docbook-xsl" => :build
  depends_on "gobject-introspection" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "libxml2"
  depends_on "pango"

  uses_from_macos "libxslt" => :build

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gtk-mac-integration"
    depends_on "harfbuzz"
  end

  def install
    # Find our docbook catalog
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    # Disable icon-cache update
    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", "-Dintrospection=true", "-Dgladeui=true", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    # executable test (GUI)
    # fails in Linux CI with (glade:20337): Gtk-WARNING **: 21:45:31.876: cannot open display:
    system bin/"glade", "--version" if OS.mac?

    (testpath/"test.c").write <<~C
      #include <gladeui/glade.h>

      int main(int argc, char *argv[]) {
        gboolean glade_util_have_devhelp();
        return 0;
      }
    C

    pkgconf_flags = shell_output("pkgconf --cflags --libs gladeui-2.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *pkgconf_flags
    system "./test"
  end
end
