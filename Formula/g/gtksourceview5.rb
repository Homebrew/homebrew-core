class Gtksourceview5 < Formula
  desc "Text view with syntax, undo/redo, and text marks"
  homepage "https://projects.gnome.org/gtksourceview/"
  url "https://download.gnome.org/sources/gtksourceview/5.18/gtksourceview-5.18.0.tar.xz"
  sha256 "051a78fe38f793328047e5bcd6d855c6425c0b480c20d9432179e356742c6ac0"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/gtksourceview[._-]v?(5\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "1f9e3a56f8a065dad2316da088e50e1fa1b3e7e3dd2b7c1fe5df89e497c6e73c"
    sha256 arm64_sequoia: "cb73673087b8c50129d6136bc05457d964d52b8d47d04c266af4d24fe266d1f1"
    sha256 arm64_sonoma:  "ea85817f7a9377d4f478f61f96ec7c487681ac52ec4fb677bad934058adb5bb0"
    sha256 sonoma:        "0c635d1fece526969c585845a3c745c3ea7135f6d5af572131a7e7bffc86c68b"
    sha256 arm64_linux:   "21b402071c73160ba92de56bd03f1a88e2a43e4a535b6b5cc5a2b82c4bab0c43"
    sha256 x86_64_linux:  "5a81d0babd17eab9868f12db42382bd15196762543bd91878575656685ee5c54"
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
  depends_on "graphene"
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
