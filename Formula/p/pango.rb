class Pango < Formula
  desc "Framework for layout and rendering of i18n text"
  homepage "https://pango.gnome.org"
  url "https://download.gnome.org/sources/pango/1.54/pango-1.54.0.tar.xz"
  sha256 "8a9eed75021ee734d7fc0fdf3a65c3bba51dfefe4ae51a9b414a60c70b2d1ed8"
  license "LGPL-2.0-or-later"
  head "https://gitlab.gnome.org/GNOME/pango.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "555a0ea1e85a5f5b5d26e4bfdc1f1c19a3d1108ba0801deed64d301a6d912c58"
    sha256 cellar: :any, arm64_sonoma:   "c47cf2f24449280a2643d958e6f211a2db089f1c2cb3e9f27ef50f35701601ed"
    sha256 cellar: :any, arm64_ventura:  "1a20935a0a5377fadbb6f02c6b9689d4d5e2a6e6d489e1d9e77b0684876046a6"
    sha256 cellar: :any, arm64_monterey: "b79420edeeacdb59d0b1a131d3198f6dfcc8ec9dd3e6a4c6136271718e9ad41d"
    sha256 cellar: :any, sonoma:         "2e8dc6924252fc6df5b73a0eae636f81a9cf872ac654ce08a7866f00f2169e5f"
    sha256 cellar: :any, ventura:        "11d51f9281cd68d0b8718158df55bc28029e25956f1ad313cae99b31ae130dbb"
    sha256 cellar: :any, monterey:       "03e0d179c3a4c47cf210c52073a2eee075013ee5617b026abc13aafc45f8ee22"
    sha256               x86_64_linux:   "3cdf86a860b1e40093330d83b705cfdc326f2974332d65565e2ce8e15c9213b8"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
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
    (testpath/"test.c").write <<~EOS
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
    EOS

    flags = shell_output("pkg-config --cflags --libs pangocairo").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
