class Pango < Formula
  desc "Framework for layout and rendering of i18n text"
  homepage "https://www.gtk.org/docs/architecture/pango"
  url "https://download.gnome.org/sources/pango/1.56/pango-1.56.4.tar.xz"
  sha256 "17065e2fcc5f5a5bdbffc884c956bfc7c451a96e8c4fb2f8ad837c6413cb5a01"
  license "LGPL-2.0-or-later"
  head "https://gitlab.gnome.org/GNOME/pango.git", branch: "main"

  # Pango doesn't follow GNOME's "even-numbered minor is stable" version
  # scheme but they do appear to use 90+ minor/patch versions, which may
  # indicate unstable versions (e.g., 1.90, etc.).
  livecheck do
    url "https://download.gnome.org/sources/pango/cache.json"
    regex(/pango[._-]v?(\d+(?:(?!\.9\d)\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "9d66411f935f57a8f54642855505f4da5b056bc44526daca9bdbfd32552c4542"
    sha256 cellar: :any, arm64_sonoma:  "cb37e3ffe4b548c34c47d5c482fb7c02005410232b8c16a56c8b78a385a999ba"
    sha256 cellar: :any, arm64_ventura: "4558dd7cff43901e22f44496838179b26738b175fc260a550272dbbd3ab70893"
    sha256 cellar: :any, sonoma:        "03a76dd1f0f289418ac065fdabfbf3a4391962587975f63fd33a109da1f52c0b"
    sha256 cellar: :any, ventura:       "ea6bdcc8e09a610ba22ec6b260f5b61a4ab539c37fafc9b5ec177c49f581eba8"
    sha256               arm64_linux:   "440ead39116f7d2295d60b7c9bd4194e7ea46366feeaac6174b60e2cab827650"
    sha256               x86_64_linux:  "75c1fde372973f6e3af8efce49596fe3c18971cf4f80f072bf389e5282e6e111"
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
