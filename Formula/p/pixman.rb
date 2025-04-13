class Pixman < Formula
  desc "Low-level library for pixel manipulation"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/releases/pixman-0.44.2.tar.gz"
  sha256 "6349061ce1a338ab6952b92194d1b0377472244208d47ff25bef86fc71973466"
  license "MIT"

  livecheck do
    url "https://cairographics.org/releases/?C=M&O=D"
    regex(/href=.*?pixman[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8ec43a3f69d7c97d8ce1d07611638040c8ebec305e7dd76cb02dc3609982fa9f"
    sha256 cellar: :any,                 arm64_sonoma:  "9864683edbe6d854ac00331ede5a69e8fcd624dda02d27c7e240a0c6b9e73feb"
    sha256 cellar: :any,                 arm64_ventura: "9ba0bb20e92ef367e72978e2d73f4fe15567d5ce5624ddc095f1fc7774dcfce4"
    sha256 cellar: :any,                 sonoma:        "d5cad71f43737f7c3d0dbfa3658c315f59253f965d69a32c308ae6e4ed601852"
    sha256 cellar: :any,                 ventura:       "b705fc0334ba602eef3ed78f672b00b95f9564bdfb387c9d1b519e8a7a1cb560"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f4f787e267696d6900a9ccdb7319df66b8279d3f36c410a87b7234a89a74108"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6825da7bb96ac0019357cc7425c98ec6e578642c06c48e8c6bf89877181e8805"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <pixman.h>

      int main(int argc, char *argv[])
      {
        pixman_color_t white = { 0xffff, 0xffff, 0xffff, 0xffff };
        pixman_image_t *image = pixman_image_create_solid_fill(&white);
        pixman_image_unref(image);
        return 0;
      }
    C

    pkgconf_flags = shell_output("pkgconf --cflags --libs pixman-1").chomp.split
    system ENV.cc, "test.c", "-o", "test", *pkgconf_flags
    system "./test"
  end
end
