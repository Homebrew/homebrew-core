class Gtksourceview3 < Formula
  desc "Text view with syntax, undo/redo, and text marks"
  homepage "https://projects.gnome.org/gtksourceview/"
  url "https://download.gnome.org/sources/gtksourceview/3.24/gtksourceview-3.24.11.tar.xz"
  sha256 "691b074a37b2a307f7f48edc5b8c7afa7301709be56378ccf9cc9735909077fd"
  license "LGPL-2.1-or-later"
  revision 4

  livecheck do
    url :stable
    regex(/gtksourceview[._-]v?(3\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "52fd0b688066b7ae0c5d9a87ddb185136dbeebd11b336ae776eeed43f4ce6399"
    sha256 arm64_ventura:  "c0e6dcec74dcad611bbd070ec935726d1a6e2ab55db8de33fd1aff89171cca21"
    sha256 arm64_monterey: "1478db6878ebe7cf4e472197126c565df4ea939aeb91470a610cfe88ce3de7b0"
    sha256 sonoma:         "79296a156876f62aed3b1025d8dd869403562d03ed112d118d1076496e3cd8ef"
    sha256 ventura:        "fb3887ecc8c0938f012b851eaba6c3025ed6836f54aad8cd07e5d367c63084bd"
    sha256 monterey:       "e72638ee3511326f622b20975c568d0b0f054c318ae944b15505d1816af10c2d"
    sha256 x86_64_linux:   "a29fc106c186da13c48399358ec0152907ca4bc3be2545632400409aaffcce2e"
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build
  depends_on "gtk+3"

  on_macos do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
    depends_on "gettext"
  end

  def install
    system "autoreconf", "--verbose", "--install", "--force" if OS.mac?
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--enable-vala=yes",
                          "--enable-introspection=yes"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gtksourceview/gtksource.h>

      int main(int argc, char *argv[]) {
        gchar *text = gtk_source_utils_unescape_search_text("hello world");
        return 0;
      }
    EOS
    ENV.libxml2
    flags = shell_output("pkg-config --cflags --libs gtksourceview-3.0").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
