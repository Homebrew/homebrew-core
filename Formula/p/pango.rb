class Pango < Formula
  desc "Framework for layout and rendering of i18n text"
  homepage "https://www.gtk.org/docs/architecture/pango"
  url "https://download.gnome.org/sources/pango/1.56/pango-1.56.3.tar.xz"
  sha256 "2606252bc25cd8d24e1b7f7e92c3a272b37acd6734347b73b47a482834ba2491"
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
    sha256 cellar: :any, arm64_sequoia: "39c8338524e71bf6019b72a2bbebebc78c6935dfad75a76db43ff9a8815bfe6b"
    sha256 cellar: :any, arm64_sonoma:  "10d76601d1eee9482d66a31d570c6704bb318eead6f83ec1404d6e520be581f2"
    sha256 cellar: :any, arm64_ventura: "4d619b28828586db45c6eee3e82b1aca65596af17195a6b975c3b9fa7ccad963"
    sha256 cellar: :any, sonoma:        "2e141cb0c33eb33fd2771efbac614b75dad3db4ed332ef84526e81e6a64b7d01"
    sha256 cellar: :any, ventura:       "cbc5448e13f060afeb0aee80cba9fd228f4a8e199761c4a4114b39700e840c39"
    sha256               arm64_linux:   "751a44f3853807b2ed64eaa5bfddf90cbd5bd4095a2d3e6c5939196355e219e8"
    sha256               x86_64_linux:  "cdcdca05be1495b3afd63d5b1951040e359278ee8bfbcbb65e37128c844a3737"
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
