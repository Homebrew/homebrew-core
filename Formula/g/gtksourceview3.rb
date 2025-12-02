class Gtksourceview3 < Formula
  desc "Text view with syntax, undo/redo, and text marks"
  homepage "https://projects.gnome.org/gtksourceview/"
  url "https://download.gnome.org/sources/gtksourceview/3.24/gtksourceview-3.24.11.tar.xz"
  sha256 "691b074a37b2a307f7f48edc5b8c7afa7301709be56378ccf9cc9735909077fd"
  license "LGPL-2.1-or-later"
  revision 5

  livecheck do
    url :stable
    regex(/gtksourceview[._-]v?(3\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "72ddfb15569484b9703111b8e49c012ef5b58ef5e13c528d7b69773e1033826e"
    sha256 arm64_sequoia: "8260f146baeaee7420598450f7c4929891722c45afd354a601c8ff1f9ee60b71"
    sha256 arm64_sonoma:  "f18f2ad10cc993eb869c07f4be3a493eca3e1f0548dd4c4cd89957ce3d3148c8"
    sha256 sonoma:        "0f7bc2f472cdfcc84b6010bf32748e1244e695b899d946d8b49513fac2907c7b"
    sha256 arm64_linux:   "e2c6ba8b631090fdd53be054401f3446d36c4efeb4c5032e40304c92cad14dee"
    sha256 x86_64_linux:  "c7614f41dcc75bd7ecd2b004547af214c35199b55d9aa0e1040f57239938f03c"
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "pango"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if OS.mac?

    system "./configure", "--disable-silent-rules",
                          "--enable-vala=yes",
                          "--enable-introspection=yes",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gtksourceview/gtksource.h>

      int main(int argc, char *argv[]) {
        gchar *text = gtk_source_utils_unescape_search_text("hello world");
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs gtksourceview-3.0").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
