class Cairo < Formula
  desc "Vector graphics library with cross-device output support"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/releases/cairo-1.18.6.tar.xz"
  sha256 "1c767308174337a74694da0f3ec069c271452163a1ef4540964c50c301f157d4"
  license any_of: ["LGPL-2.1-only", "MPL-1.1"]
  compatibility_version 1
  head "https://gitlab.freedesktop.org/cairo/cairo.git", branch: "master"

  livecheck do
    url "https://cairographics.org/releases/?C=M&O=D"
    regex(%r{href=(?:["']?|.*?/)cairo[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1dab52f452b0eb0a90432a5f1022529abaab3aaa83b36b9e0edde404ee168f0e"
    sha256 cellar: :any, arm64_tahoe:       "e067e63e664c7d95bdff0a08a293b4a0182a26f38b750f5f7958012e00823416"
    sha256 cellar: :any, arm64_sequoia:     "2eb1ea8f47088a4bddf68c052eef3ef5e52a5bc1369118d432db6bea2e363853"
    sha256 cellar: :any, arm64_linux:       "7608281ea691a911abee820f95200dfcbdfc5396511f842fb05196521e025cd5"
    sha256 cellar: :any, x86_64_linux:      "5fd48263c0683b91d89c475f500db3bcd00178490005646cb6b09d57d7b30c91"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "glib"
  depends_on "libpng"
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "libxext"
  depends_on "libxrender"
  depends_on "lzo"
  depends_on "pixman"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %w[
      --default-library=both
      -Dfontconfig=enabled
      -Dfreetype=enabled
      -Dpng=enabled
      -Dglib=enabled
      -Dxcb=enabled
      -Dxlib=enabled
      -Dzlib=enabled
      -Dglib=enabled
    ]
    args << "-Dquartz=enabled" if OS.mac?

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <cairo.h>

      int main(int argc, char *argv[]) {

        cairo_surface_t *surface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, 600, 400);
        cairo_t *context = cairo_create(surface);

        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs cairo").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
