class Pixman < Formula
  desc "Low-level library for pixel manipulation"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/releases/pixman-0.46.2.tar.gz"
  sha256 "3e0de5ba6e356916946a3d958192f15505dcab85134771bfeab4ce4e29bbd733"
  license "MIT"

  livecheck do
    url "https://cairographics.org/releases/?C=M&O=D"
    regex(/href=.*?pixman[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "562fd713cba6bd2d1b67efc0985e25a0540243c6af8bcfb1add2c59e79a6a4c6"
    sha256 cellar: :any,                 arm64_sonoma:  "c987aaa3c13f36ba7f1d09b7c6e1551caca2b766a8a3483ee78f1be6af099904"
    sha256 cellar: :any,                 arm64_ventura: "d95aaa640c1545ca252fc63356c15ac1922cdf12a1b3b53c0a7cc81d37f56d6b"
    sha256 cellar: :any,                 sonoma:        "e36b4e62524a998dfcba997b3e827537ef8179df9f9c558e203476cd264e2c9f"
    sha256 cellar: :any,                 ventura:       "76bf47b17df80924d7e3e181756bc4b626726fb3edbb64712f8efaf3a9084390"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0348b9a6b322df730a5b2d6486f48ab5ffa7417bfb7d82470159c8c25f3bd9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dae8493d70813d203b6e05abbf9297edff4c5b94320fe74492198f9169930f09"
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
