class Pango < Formula
  desc "Framework for layout and rendering of i18n text"
  homepage "https://www.gtk.org/docs/architecture/pango"
  url "https://download.gnome.org/sources/pango/1.58/pango-1.58.0.tar.xz"
  sha256 "bc5bad6213ad4886a47d1e80292fd850b64159b50db67917a43d9ea80ee2298a"
  license "LGPL-2.0-or-later"
  compatibility_version 1
  head "https://gitlab.gnome.org/GNOME/pango.git", branch: "main"

  # Pango doesn't follow GNOME's "even-numbered minor is stable" version
  # scheme but they do appear to use 90+ minor/patch versions, which may
  # indicate unstable versions (e.g., 1.90, etc.).
  livecheck do
    url "https://download.gnome.org/sources/pango/cache.json"
    regex(/pango[._-]v?(\d+(?:(?!\.9\d)\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a522f4aa3ed2f9b3774b9bbb11247de251b3cf730ca774d8cb2b7772df49b81b"
    sha256 cellar: :any, arm64_sequoia: "4cb6631c3d5ca8fc796495d0dba2e6a104c421dc043fc81b1dfe64af8ebbecdf"
    sha256 cellar: :any, arm64_sonoma:  "c3248ed815475e11fa44d7e4d59fc3d9b8e08d324b30974185e5e83efbd15760"
    sha256 cellar: :any, sonoma:        "20b3b56762a6af2ca9ddb73799bdec37e6860d08d6c82b91fad2168f5dcb0f52"
    sha256               arm64_linux:   "0ed67a33b54ee6f9f8c25a97f8f7aed1ac12a8386bb229d601a2cb65165d2ba0"
    sha256               x86_64_linux:  "a45a7d251e0076f3fcd40b4ce86b1d8a7100d0359d0cc3d0693218de2becfea1"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "fribidi"
  depends_on "glib"
  depends_on "harfbuzz"
  depends_on "libthai"

  def install
    args = %w[
      -Ddefault_library=both
      -Dintrospection=enabled
      -Dfontconfig=enabled
      -Dcairo=enabled
      -Dfreetype=enabled
      -Dlibthai=enabled
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"pango-view", "--version"
    (testpath/"test.c").write <<~C
      #include <pango/pangocairo.h>

      int main(int argc, char *argv[]) {
        PangoFontMap *fontmap;
        int n_families;
        PangoFontFamily **families;
        fontmap = pango_cairo_font_map_get_default();
        pango_font_map_list_families (fontmap, &families, &n_families);
        g_free(families);
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs pangocairo").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
