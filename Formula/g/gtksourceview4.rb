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
    sha256 arm64_sequoia:  "dbadf71a71df5660b4855749181a8048299376c37903aa7e1fa289be203b0446"
    sha256 arm64_sonoma:   "b07d4c344cf2681c5b78e3ee653a8d2933751508b6378707532e570dc2afa3f9"
    sha256 arm64_ventura:  "b605b5be2be86a227af210c2398f1a5d34758e168a5bb126dfb75839cddd587a"
    sha256 arm64_monterey: "1dae085692a3cddc818ff2f9ff6e0bac0f53c66919542f02fb62eae6f07e67e9"
    sha256 sonoma:         "aca0bb196750a51686d4a2f888da6c6d181f69963885f57ab28b6e77a2826c74"
    sha256 ventura:        "7ea3859293d9a4269b11508de891517a476ee67c00c8eb06cedc2e3e29e91930"
    sha256 monterey:       "cf4d2ec936cabc42216f9e1818a1df4019fdf245b9e9fa6da4ac316b33fbafa7"
    sha256 x86_64_linux:   "7de3d2953794fcc913a18ecc93fa3e615598fdb8a2306ad48554c38e611a021d"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
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
    (testpath/"test.c").write <<~EOS
      #include <gtksourceview/gtksource.h>

      int main(int argc, char *argv[]) {
        gchar *text = gtk_source_utils_unescape_search_text("hello world");
        return 0;
      }
    EOS

    pkg_config_flags = shell_output("pkg-config --cflags --libs gtksourceview-4").chomp.split
    system ENV.cc, "test.c", "-o", "test", *pkg_config_flags
    system "./test"
  end
end
