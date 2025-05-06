class Gtksourceview4 < Formula
  desc "Text view with syntax, undo/redo, and text marks"
  homepage "https://projects.gnome.org/gtksourceview/"
  url "https://download.gnome.org/sources/gtksourceview/4.8/gtksourceview-4.8.4.tar.xz"
  sha256 "7ec9d18fb283d1f84a3a3eff3b7a72b09a10c9c006597b3fbabbb5958420a87d"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/gtksourceview[._-]v?(4\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "938b87e409e99e8a9459001a8f2d618d6a11777a60bcd8b083d20569c9f7e000"
    sha256 arm64_sonoma:  "9585d13d6b48522730b5e44320f732b96ff69a53a8ea4c716e0944bd167437ca"
    sha256 arm64_ventura: "d0594d55fadba6bb175be05c699167f109d1c062ba46f93b5a2b987707ed63cf"
    sha256 sonoma:        "397d7f712188423f7072a085f7df8c0f460038acce0287308d92ec5f2789f881"
    sha256 ventura:       "53dbd9908d978f3fda45fed54f5aaa9fc494a00529cb8f57364846b21c269bab"
    sha256 arm64_linux:   "a00ce1afcd0d97788a9e601e9a33a423a0a9e8abc77d9f5d1ab3105579f1fdfa"
    sha256 x86_64_linux:  "c441529f7e87e35ad9b92422aa394f77109f57c25a7eace6e368d3db8f95b54b"
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
