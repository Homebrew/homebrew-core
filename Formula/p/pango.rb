class Pango < Formula
  desc "Framework for layout and rendering of i18n text"
  homepage "https://www.gtk.org/docs/architecture/pango"
  url "https://download.gnome.org/sources/pango/1.57/pango-1.57.0.tar.xz"
  sha256 "890640c841dae77d3ae3d8fe8953784b930fa241b17423e6120c7bfdf8b891e7"
  license "LGPL-2.0-or-later"
  revision 1
  head "https://gitlab.gnome.org/GNOME/pango.git", branch: "main"

  # Pango doesn't follow GNOME's "even-numbered minor is stable" version
  # scheme but they do appear to use 90+ minor/patch versions, which may
  # indicate unstable versions (e.g., 1.90, etc.).
  livecheck do
    url "https://download.gnome.org/sources/pango/cache.json"
    regex(/pango[._-]v?(\d+(?:(?!\.9\d)\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "dd27a8a5aa57deade2909c9f8054000cf8f289e4c416b3448c4c71159941e941"
    sha256 cellar: :any, arm64_sequoia: "b81624cd5d7a41cfa1242840ca5d8deb0e03e9fa1951841690fa1a94291293ef"
    sha256 cellar: :any, arm64_sonoma:  "6edeafd5ccd0552dfa16d7790ab1e07a736076bfead4998d4e8222ae430e7ddc"
    sha256 cellar: :any, sonoma:        "ae4ef39435487540dff3163e170936841edd376cd6ca56d5f4ba9765ce8f144e"
    sha256               arm64_linux:   "20e27986a4cb125faff80a45c80e3bf052f0f47deedb1f845f85010185d43ffa"
    sha256               x86_64_linux:  "0d6b77557f01f42a3143618f129f096403ac2fb84475017057b7d9fd09f00261"
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

  # PR ref: https://gitlab.gnome.org/GNOME/pango/-/merge_requests/891
  patch do
    url "https://gitlab.gnome.org/GNOME/pango/-/commit/4403954455f2b4a815b32e11c44f79b2e665e94c.diff"
    sha256 "f674089884839f64b5c04032325c2230f19049759a94dcb1daf82f832ff70e33"
  end

  def install
    args = %w[
      -Ddefault_library=both
      -Dintrospection=enabled
      -Dfontconfig=enabled
      -Dcairo=enabled
      -Dfreetype=enabled
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
