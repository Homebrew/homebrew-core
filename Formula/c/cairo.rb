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
    rebuild 2
    sha256 cellar: :any, arm64_tahoe:   "3099d9356456b9aced4b35bfb6723c45014c09d7b090190bcd8d17053244dd3c"
    sha256 cellar: :any, arm64_sequoia: "91a09ffb4c4025f8204305e25c9d16b5d9e3427c65baabe8a11c7c5e6e07e29e"
    sha256 cellar: :any, arm64_sonoma:  "28602bd6232c6f102f2f545662a8ea5db0ef1405de2c5296bd8490c910f391af"
    sha256 cellar: :any, sonoma:        "8eac751ce30d7e665220bb02d2bd7aa209c041951edca3439918554e9dcb0e63"
    sha256               arm64_linux:   "8d2393d42a2e6b4abda5d72981614960f30d35599f9a213944d3948b085529d7"
    sha256               x86_64_linux:  "3d852e0bcef8e7bf1f4e5b9defa709da64a2dc2dcef4c35d177cebdbf552e65b"
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
