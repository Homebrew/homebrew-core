class Pango < Formula
  desc "Framework for layout and rendering of i18n text"
  homepage "https://www.gtk.org/docs/architecture/pango"
  url "https://download.gnome.org/sources/pango/1.57/pango-1.57.0.tar.xz"
  sha256 "890640c841dae77d3ae3d8fe8953784b930fa241b17423e6120c7bfdf8b891e7"
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
    sha256 cellar: :any, arm64_tahoe:   "cc25f12c05e5a49b2d73b0c4161554f72dce3b813ad9790ed94f146564e4a79f"
    sha256 cellar: :any, arm64_sequoia: "af46edb4113ff0190d78175fb4e82296467cef2ed216267bcc3b26f151b2fe0a"
    sha256 cellar: :any, arm64_sonoma:  "5574b80791985eddd56246754eae3b4d35404fef8618d217595dbcd115e87cf9"
    sha256 cellar: :any, arm64_ventura: "a540a741aa1f48d1aa12a4da48c14ed0684f7622e5f5c00acbec5fbf8cdbad08"
    sha256 cellar: :any, sonoma:        "2e14b5c3420123b2d1fee02cbf9e9bffebfbe680ba116353bd44faa598ec9d14"
    sha256 cellar: :any, ventura:       "901790521cdaa6ed8a4ca3161a7afdb954d2d8e3d65460f47d7393a3c9ca7fe4"
    sha256               arm64_linux:   "0fe86be52c9a3244e9badf8116eaf985003ca39aff68957a3e4082a1bc5bfac0"
    sha256               x86_64_linux:  "e4e73119da00a975bb646eed9d6fadea31032286ac43ef8ff57bf7dc2edc0b20"
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
