class LibgeditGtksourceview < Formula
  desc "Text editor widget for code editing"
  homepage "https://gitlab.gnome.org/World/gedit/libgedit-gtksourceview"
  url "https://gitlab.gnome.org/World/gedit/libgedit-gtksourceview/-/archive/299.5.0/libgedit-gtksourceview-299.5.0.tar.bz2"
  sha256 "3b452764b7c0868ade614972d85f8c0388d4d65ef88ba6d41487aab97cbbedc9"
  license "LGPL-2.1-only"
  revision 1
  head "https://gitlab.gnome.org/World/gedit/libgedit-gtksourceview.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "132bf3b7f7a01f706c000ba339f693e4b1e5960fd996fac44f5ccc49fee0ae83"
    sha256 arm64_sequoia: "1b92e218971cdf1ea630f33890601d09db50587d362f5aab975d336fd7f485c0"
    sha256 arm64_sonoma:  "47473d359abc28bd6c7e71428ac468d22b8ce7b67828400c1015601faba789d2"
    sha256 sonoma:        "aad0855afc83b9e275c1070c687aa89702fff88b03d949a759d2a9f5e19e88f2"
    sha256 arm64_linux:   "bb21888d5167eb988a2ae59f90791f176b0922af3eb2763eb58947d70e00b56d"
    sha256 x86_64_linux:  "703d9b4ea400a1ac20a1b6a8e254ca4f02d19345a33e925f834a3f51b44d020a"
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
