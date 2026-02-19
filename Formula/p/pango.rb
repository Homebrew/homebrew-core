class Pango < Formula
  desc "Framework for layout and rendering of i18n text"
  homepage "https://www.gtk.org/docs/architecture/pango"
  url "https://download.gnome.org/sources/pango/1.57/pango-1.57.0.tar.xz"
  sha256 "890640c841dae77d3ae3d8fe8953784b930fa241b17423e6120c7bfdf8b891e7"
  license "LGPL-2.0-or-later"
  revision 2
  head "https://gitlab.gnome.org/GNOME/pango.git", branch: "main"

  # Pango doesn't follow GNOME's "even-numbered minor is stable" version
  # scheme but they do appear to use 90+ minor/patch versions, which may
  # indicate unstable versions (e.g., 1.90, etc.).
  livecheck do
    url "https://download.gnome.org/sources/pango/cache.json"
    regex(/pango[._-]v?(\d+(?:(?!\.9\d)\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "666e399270228506a57d243de5c340c42de149abc9c3a75b01044417f8db6222"
    sha256 cellar: :any, arm64_sequoia: "e5e1310e53ccc4258f523df667f092dcf694f01e9a700883f15121ca23fb1714"
    sha256 cellar: :any, arm64_sonoma:  "e346d0be5c3608d82e370e02cac4e0b8112a925cafe733d5f8219f593c02cf92"
    sha256 cellar: :any, sonoma:        "0da3e9d5b786f46857fa9372b8644da690f3902421f5996e9bb058525cdf6d67"
    sha256               arm64_linux:   "c3e8f72ff6a5385bd5f24ec2bf7ec1f656c11bdb6ad57cc912a35d21db6ee3cd"
    sha256               x86_64_linux:  "da9d2d48f51a6364f7e3edac502478231ccffab76ad8775ca3555ce87d39f524"
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
