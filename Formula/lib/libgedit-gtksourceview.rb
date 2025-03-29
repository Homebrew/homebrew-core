class LibgeditGtksourceview < Formula
  desc "Text editor widget for code editing"
  homepage "https://gitlab.gnome.org/World/gedit/libgedit-gtksourceview"
  url "https://gitlab.gnome.org/World/gedit/libgedit-gtksourceview/-/archive/299.5.0/libgedit-gtksourceview-299.5.0.tar.bz2"
  sha256 "3b452764b7c0868ade614972d85f8c0388d4d65ef88ba6d41487aab97cbbedc9"
  license "LGPL-2.1-only"
  revision 1
  head "https://gitlab.gnome.org/World/gedit/libgedit-gtksourceview.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "7da63cce0cba6168b56748be0ae6c0da7c7559ba67fe3752c2c0ce4a313667d9"
    sha256 arm64_sonoma:  "e4bcc56a29b6e13d3cc15c74fb09ca5bdb1c74662e0c1949cca989affce3529e"
    sha256 arm64_ventura: "ca4477e848ec00b7efb680ad7e0171bf6883ca08d0ca678034270997f352b420"
    sha256 sonoma:        "5f373605872fff3fdce72f24fdece0dbe151501bac38df500e69d12a999cd423"
    sha256 ventura:       "dc2b6a5cef2387db52487d5256816c5c84e6bbb4fe21e97210e7cf8416ec2f7a"
    sha256 x86_64_linux:  "8241a8bacd6e3ad437cbf3b1082251925235897a14e7a4b8da93fe860afd35a0"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libxml2" # Dependent `gedit` uses Homebrew `libxml2`
  depends_on "pango"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "meson", "setup", "build", "-Dgtk_doc=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gtksourceview/gtksource.h>

      int main(int argc, char *argv[]) {
        gchar *text = gtk_source_utils_unescape_search_text("hello world");
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs libgedit-gtksourceview-300").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
