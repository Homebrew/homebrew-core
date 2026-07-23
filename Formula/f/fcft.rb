class Fcft < Formula
  desc "Simple library for font loading and glyph rasterization"
  homepage "https://codeberg.org/dnkl/fcft"
  url "https://codeberg.org/dnkl/fcft/archive/3.3.3.tar.gz"
  sha256 "b0c0f4a599f43723736c8565b8b84337c4195077f07f1bb8bb3252bb13a2306a"
  license "MIT"

  bottle do
    rebuild 1
    sha256 arm64_linux:  "422fc6622e50b8938d35ef4c65ea4c712425925eaa7e53eda599de004fd239f5"
    sha256 x86_64_linux: "686fdf37a1c72b3078e5b2ff4ffabfb44c0d963034f5dc6d4fa54702dc4e0144"
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
