class LibgeditGtksourceview < Formula
  desc "Text editor widget for code editing"
  homepage "https://gitlab.gnome.org/World/gedit/libgedit-gtksourceview"
  url "https://gitlab.gnome.org/World/gedit/libgedit-gtksourceview/-/archive/299.7.1/libgedit-gtksourceview-299.7.1.tar.bz2"
  sha256 "4fbf466189d38f709bc1e69d85518027a4623cb697368718a94932caede75f58"
  license "LGPL-2.1-only"
  compatibility_version 2
  head "https://gitlab.gnome.org/World/gedit/libgedit-gtksourceview.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "14b8b5f92d882ed6bb47f2b2e192f733361b6b334a50abccd75bad671de11bdc"
    sha256 arm64_sequoia: "89e0543841098d0ccacde6dadd0097f4fd6ea6ca4bef771d76d54a0ba7a135be"
    sha256 arm64_sonoma:  "4f5c77b5abd7042d53447fa730248e5494452631358b99dbc6d6b656c0697d36"
    sha256 sonoma:        "017ed33c62c89a0ffdc809647e608029d85ab327e185f4443c81a4515f2990fb"
    sha256 arm64_linux:   "732ad27e78ae142415070f5e9ad661b5dc65235d5a0b4beb06430cf2fa99fd17"
    sha256 x86_64_linux:  "4fdd8c722e8e674ed67627c020c97db8d308c014d5c06fdf47d47c6cb503420d"
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
  depends_on "libgedit-amtk"
  depends_on "libgedit-gfls"
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
