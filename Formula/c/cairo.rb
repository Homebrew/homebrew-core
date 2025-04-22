class Cairo < Formula
  desc "Vector graphics library with cross-device output support"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/releases/cairo-1.18.4.tar.xz"
  sha256 "445ed8208a6e4823de1226a74ca319d3600e83f6369f99b14265006599c32ccb"
  license any_of: ["LGPL-2.1-only", "MPL-1.1"]
  head "https://gitlab.freedesktop.org/cairo/cairo.git", branch: "master"

  livecheck do
    url "https://cairographics.org/releases/?C=M&O=D"
    regex(%r{href=(?:["']?|.*?/)cairo[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "6b2d148a34a670430a459c374376ebed890b61eb7573e8aa952a4b909f443cee"
    sha256 cellar: :any, arm64_sonoma:  "1fd50d14699ddc03d348baeda1e3a2c98bce8fa74b248481559c3afa17b7784b"
    sha256 cellar: :any, arm64_ventura: "8ea2169c9cc4391f1a06be0b97413d11e5db2c845c65627ea122407b463c6b16"
    sha256 cellar: :any, sonoma:        "76a88eab178ee0ada4fa05270834be6808e0f6480f68002d9f21bc41ee2e1cb6"
    sha256 cellar: :any, ventura:       "44424dbd81d5e1c591c60243921fb0aea4a3bfd919d24883cd86e74d82d3bfcd"
    sha256               arm64_linux:   "af87041f90f6c3a453baa6752055b67c0f9b6419f4f3f55c8639bd131417a44d"
    sha256               x86_64_linux:  "ad2f527ee5910160b725637d97e64bea8cbfebebf6ffa8720a49c2de73763a48"
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

  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  def install
    args = %w[
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
