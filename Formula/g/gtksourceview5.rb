class Gtksourceview5 < Formula
  desc "Text view with syntax, undo/redo, and text marks"
  homepage "https://projects.gnome.org/gtksourceview/"
  url "https://download.gnome.org/sources/gtksourceview/5.16/gtksourceview-5.16.0.tar.xz"
  sha256 "ab35d420102f3e8b055dd3b8642d3a48209f888189e6254d0ffb4b6a7e8c3566"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/gtksourceview[._-]v?(5\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "847a0f3517ce808dd4a6e17761a8d6a7fff953898c9afe848920b68e851c5d49"
    sha256 arm64_sonoma:  "ee4435516bcc7bc5d48e05bbab28ab416f937e83d8762019b1f761ec888f67a3"
    sha256 arm64_ventura: "d372e735e12c374d561a49efe49f574a00cc4270335f05d662fe44c0a05b35bc"
    sha256 sonoma:        "924fe9d5f721db208b762410862d6da3d10578e6943e9b3082c4df3d532ee7f8"
    sha256 ventura:       "bccd0d2fff52f29f15f327a7950a57953a072d4b8682dd4b79f7c2c3926b18b4"
    sha256 arm64_linux:   "ba5eaeff438f6a378817ce099509f651fd8188c9131e03c849e0647922ee208c"
    sha256 x86_64_linux:  "3664b8119abd306259ab0ac62fb6ba02cb50e3a9e4db2efdb94319cdc3079b16"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "fribidi"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "pango"
  depends_on "pcre2"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  def install
    args = %w[
      -Dintrospection=enabled
      -Dvapi=true
    ]

    system "meson", "setup", "build", *args, *std_meson_args
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

    flags = shell_output("pkgconf --cflags --libs gtksourceview-5").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
