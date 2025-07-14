class Fcft < Formula
  desc "Simple library for font loading and glyph rasterization"
  homepage "https://codeberg.org/dnkl/fcft"
  url "https://codeberg.org/dnkl/fcft/archive/3.3.1.tar.gz"
  sha256 "f18bf79562e06d41741690cd1e07a02eb2600ae39eb5752eef8a698f603a482c"
  license "MIT"

  bottle do
    sha256 arm64_linux:  "97a0e6e9910f16cf36220973b5ff3f710024aeb0342e9f72b3946f80953c0df7"
    sha256 x86_64_linux: "25df5af63145cf3ccdda4f57c5f24ba0adae0535fa6fc2a0cb8307e28ed9451a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "scdoc" => :build
  depends_on "tllist" => :build

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on :linux
  depends_on "pixman"
  depends_on "utf8proc"

  def install
    system "meson", "setup", "build", "-Ddocs=enabled", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    pkgshare.install "example"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <fcft/fcft.h>

      int main() {
        printf("%u", fcft_capabilities());
      }
    C

    pixman = Formula["pixman"]
    utf8proc = Formula["utf8proc"]

    flags = %W[
      -I#{include}
      -I#{pixman.include}/pixman-1
      -I#{utf8proc.include}
      -L#{lib}
      -L#{pixman.lib}
      -L#{utf8proc.lib}
      -lfcft
      -lpixman-1
      -lutf8proc
    ]

    system ENV.cc, "test.c", "-o", "test", *flags
    assert_equal "7", shell_output("./test")
  end
end
