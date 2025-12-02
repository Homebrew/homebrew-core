class Gtksourceview4 < Formula
  desc "Text view with syntax, undo/redo, and text marks"
  homepage "https://projects.gnome.org/gtksourceview/"
  url "https://download.gnome.org/sources/gtksourceview/4.8/gtksourceview-4.8.4.tar.xz"
  sha256 "7ec9d18fb283d1f84a3a3eff3b7a72b09a10c9c006597b3fbabbb5958420a87d"
  license "LGPL-2.1-or-later"
  revision 2

  livecheck do
    url :stable
    regex(/gtksourceview[._-]v?(4\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "cf116d257b9203f04a8c94b4a1f108d7cda39aa99204c2d676bd568e49a91d2b"
    sha256 arm64_sequoia: "140a902d39fda0c6b0d88f6999ff0f00ed82871520bc680b4e1158bcb50d26ea"
    sha256 arm64_sonoma:  "3bd22353cc08228ca116f66f2ac18351b31b1582562a03010d0f7fca6766f890"
    sha256 sonoma:        "417952ba6c8701a201a9139abf5c6c9b23df98050b6ed76ce0d468bce25ef1f8"
    sha256 arm64_linux:   "840c123f04d4684b34b902cf69297a15900cd055269c6cae4e05a9468729c770"
    sha256 x86_64_linux:  "d9a2f07312d927bbad589dd5fe36d6b3a87d423b21992ce3aa505bd1963db23a"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "fribidi"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "pango"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "meson", "setup", "build", "-Dgir=true", "-Dvapi=true", *std_meson_args
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

    flags = shell_output("pkgconf --cflags --libs gtksourceview-4").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
