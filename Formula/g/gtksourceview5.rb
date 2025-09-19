class Gtksourceview5 < Formula
  desc "Text view with syntax, undo/redo, and text marks"
  homepage "https://projects.gnome.org/gtksourceview/"
  url "https://download.gnome.org/sources/gtksourceview/5.18/gtksourceview-5.18.0.tar.xz"
  sha256 "051a78fe38f793328047e5bcd6d855c6425c0b480c20d9432179e356742c6ac0"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/gtksourceview[._-]v?(5\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "dc47606253425fa7daffd8d1dc0bd26e859ad9fe09a291ff5f422b3f69aec028"
    sha256 arm64_sequoia: "31412b744f83cd14f5ea90decb0247c0e3030251c02508a235ac24dafbc34e2d"
    sha256 arm64_sonoma:  "09f6fbd7eccac73644ac751a32ee33cb51ad5974e872b688c5e291ee60b2c26f"
    sha256 sonoma:        "9fafff0c60954a22c83975374b66bc6288964921149ff699da39455cb73f70b0"
    sha256 arm64_linux:   "0b95950dab5c13673929ff0171d4d2c874835535fa3b919fbd28003a98a19c8c"
    sha256 x86_64_linux:  "a1745eaba8ab6ff78fab87c8e567bd8d626a16858b95bd7986df7cd5bdfd5ca4"
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
