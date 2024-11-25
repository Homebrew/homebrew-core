class Pixman < Formula
  desc "Low-level library for pixel manipulation"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/releases/pixman-0.44.0.tar.gz"
  sha256 "89a4c1e1e45e0b23dffe708202cb2eaffde0fe3727d7692b2e1739fec78a7dac"
  license "MIT"

  livecheck do
    url "https://cairographics.org/releases/?C=M&O=D"
    regex(/href=.*?pixman[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b26be1b25cf0bdda8c0d59d991ddfa34a3c220c42a3008872491c5e83973485c"
    sha256 cellar: :any,                 arm64_sonoma:  "3c7d27ea7cc15c0283badcc09ee681c7d34aa368d1f73a078a616514e94dface"
    sha256 cellar: :any,                 arm64_ventura: "375eefc10510f6061e00967ca595cdadce5a42540ed54665f8fe1220ce50b338"
    sha256 cellar: :any,                 sonoma:        "95af491e269b608248d34c4dbc31a8bd3d06bb02b36a7519c44521e184ee8459"
    sha256 cellar: :any,                 ventura:       "ab1538d1bd569f5183a9482e6f3399b5342bf9c5d5634c8dafc1ae056a0c1877"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cf37e617951c3acc3f85ccb404e76be4a0e3b62a92467126a6448743530af5c"
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
