class Pango < Formula
  desc "Framework for layout and rendering of i18n text"
  homepage "https://www.gtk.org/docs/architecture/pango"
  url "https://download.gnome.org/sources/pango/1.58/pango-1.58.2.tar.xz"
  sha256 "342385b6ca3b7c73455d7c80a13b7dbe4489e00bc3bd4c5bd6ed4dce421e374a"
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
    sha256 cellar: :any, arm64_tahoe:   "ae012e8ca99935e80984e467dff6793b80095e30e042ef5a9f71af2802345cbf"
    sha256 cellar: :any, arm64_sequoia: "64a319df708989e5a6a2ad6e83e2bed3974df0350da2e2d2b4c85792ef6b7d5e"
    sha256 cellar: :any, arm64_sonoma:  "0736011a5fa723602348faf53b36df3b2624b506cd02ca0b8a22700224608e6d"
    sha256 cellar: :any, sonoma:        "95dd77490dbc5b7df15e65226a9dd01b940a028b09c821666f7e5242e0ec65b6"
    sha256               arm64_linux:   "736526755a01554f7c3ed653fdd2d8364b9687a369b68a7a2a31f53ac054f57e"
    sha256               x86_64_linux:  "c650fcdbdb4653a2778caf71326b7c9709323057bf725172b00deec8e5da2d81"
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

  deny_network_access!

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
