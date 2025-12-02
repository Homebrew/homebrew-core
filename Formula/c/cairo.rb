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
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "0a59b15b0790cfdd761af1c0fcb82264fd3fbd9a75202bd2e194fc98999c12ec"
    sha256 cellar: :any, arm64_sequoia: "c3c657a2dd0fac3e84d3c5d4e8327313f0ef217f26da2f73fbc50765fc9e9502"
    sha256 cellar: :any, arm64_sonoma:  "af9f8ed4d44e37149a44f1a6cfdca8bacb7034690dcaa39619485171b15cbc26"
    sha256 cellar: :any, arm64_ventura: "36d4e7c07a598f0aaf9190b4cd5203daa9ca613af73b152c5c6db12ccd235869"
    sha256 cellar: :any, sonoma:        "a29a888d7f2cdf008c4e0525a72e3f5ad68c7917b830dad7c3d66f6e050fa4a2"
    sha256 cellar: :any, ventura:       "4ce538d943ce70f5f9c7f10c3655e1385ef65172d2e26add2fc721901b170dfd"
    sha256               arm64_linux:   "707c35672e01d67c2f6de3a7db40c9f6bf305d50ba71e58d4004896263743c89"
    sha256               x86_64_linux:  "829f25c2b757e94571913ec6857d454c26d0bc729a154f067ad33ac985c47a00"
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
