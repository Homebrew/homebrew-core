class Fcft < Formula
  desc "Simple library for font loading and glyph rasterization"
  homepage "https://codeberg.org/dnkl/fcft"
  url "https://codeberg.org/dnkl/fcft/archive/3.1.10.tar.gz"
  sha256 "4f4807d708f3a195e9a3caaa1ff9171b678af63a7af1c470a8984d601a4514de"
  license "MIT"

  bottle do
    sha256 x86_64_linux: "6f93a24ffc0f03550f6cb726be60a8a8e5a5ddd5e30cee7d6d208360f0345daf"
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
