class LibgeditGtksourceview < Formula
  desc "Text editor widget for code editing"
  homepage "https://gitlab.gnome.org/World/gedit/libgedit-gtksourceview"
  url "https://gitlab.gnome.org/World/gedit/libgedit-gtksourceview/-/archive/299.4.0/libgedit-gtksourceview-299.4.0.tar.bz2"
  sha256 "a2b4901b50fa2f7c5f968576e2d556b5e8e51ad264ab0d7b0e9aadced3b88f8a"
  license "LGPL-2.1-only"
  head "https://gitlab.gnome.org/World/gedit/libgedit-gtksourceview.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "51e58da55a5594fa1d73043fa7a0510d691f0c30744c127eadaba07e8663af24"
    sha256 arm64_sonoma:  "cc63f8322b34f5502c473d4b67daeeba4d1d6c0bc2291daadf555f04d68fc583"
    sha256 arm64_ventura: "209e7cbabf6f1b4884f89cf5aa1f7eb1c18da3b5b3b9dd1cbe786a246f8ff5ed"
    sha256 sonoma:        "d924112a93e2fc31602bed2f22eb62e86433770b1b5a358f10c5595814fb7ab8"
    sha256 ventura:       "786856621ac7e553e9a6a38af06d04f51d6c69e526cb9fa6260040130a34c33f"
    sha256 x86_64_linux:  "ad02ed5c3a3d39863ff6f169819c2d0854e800a3b92edece02b9a76cbab9668d"
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
