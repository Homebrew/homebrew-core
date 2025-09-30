class Pixman < Formula
  desc "Low-level library for pixel manipulation"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/releases/pixman-0.46.4.tar.gz"
  sha256 "d09c44ebc3bd5bee7021c79f922fe8fb2fb57f7320f55e97ff9914d2346a591c"
  license "MIT"

  livecheck do
    url "https://cairographics.org/releases/?C=M&O=D"
    regex(/href=.*?pixman[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "2b011051909d7f9ad432a76d32c0490f796ad545f7acbd6445356024f0c712e5"
    sha256 cellar: :any,                 arm64_sequoia: "86f5fc013d2b22bbe41c1c14661287bf8e8e4c3ac95cd05b08b886d24918fe34"
    sha256 cellar: :any,                 arm64_sonoma:  "13dbd43835c979d6857f9b0e29a9eba81fadc0804f11cad392fb344f27a71f9b"
    sha256 cellar: :any,                 arm64_ventura: "3cf671513baea31dfd16eb5ac688e23ed6c8209e0688ba96e2aa994e34c17676"
    sha256 cellar: :any,                 sonoma:        "491c963c8c80dc12305465d1191e4f29670a0cbda311d741ef8d074660392abc"
    sha256 cellar: :any,                 ventura:       "76ca1ceb7abe16fc7980e4b49284c64fc91868a98cb0bea14c3602685ba67281"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c16a1c1e8cfd9b07b36f2c53eac2e8ab8d6b26e9c2961ff060588b8a60b217d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acad642a52a0e39159ba340f1e676c63d014422bf1d90e218ba7397b5873a2d1"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  def install
    system "meson", "setup", "build", "--default-library=both", *std_meson_args
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
