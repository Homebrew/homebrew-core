class Libxfont2 < Formula
  desc "X11 font rasterisation library"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/lib/libXfont2-2.0.9.tar.gz"
  sha256 "8564b4df365bc5a6cb0c15900dc688f6e8f47b00a8571c6708c916dfb85066ba"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f4cd727130ba3dc89230f6bee3c6e312da697f31ad4bc2d6f12d0d39e92d2d71"
    sha256 cellar: :any, arm64_sequoia: "e58817e7dbe12b140db1a615a4aece5cca70fa25977db41a9c50c637448e59cf"
    sha256 cellar: :any, arm64_sonoma:  "720c1277721acc179b101f27a0eb3c746d1e613e8d1dfb264c39e7471e91eb34"
    sha256 cellar: :any, sonoma:        "4e12fb4f7f40d87c59b1f777685c31c0255385ebc8df648ff54d45478ed7a816"
    sha256 cellar: :any, arm64_linux:   "be37414a13a5dd0092d392688c4d6398798b150a4337a118790eab529a8612d8"
    sha256 cellar: :any, x86_64_linux:  "deaf074871a7424aa2fc1c8d16d4b035dd18ed9600765b58f55c3d9611cdb4b5"
  end

  depends_on "pkgconf" => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto" => [:build, :test]
  depends_on "xtrans" => :build

  depends_on "freetype"
  depends_on "libfontenc"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    configure_args = %w[
      --with-bzip2
      --enable-devel-docs=no
      --enable-snfformat
      --enable-unix-transport
      --enable-tcp-transport
      --enable-ipv6
    ]

    system "./configure", *configure_args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stddef.h>
      #include <X11/fonts/fontstruct.h>
      #include <X11/fonts/libxfont2.h>

      int main(int argc, char* argv[]) {
        xfont2_init(NULL);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test",
      "-I#{include}", "-I#{Formula["xorgproto"].include}",
      "-L#{lib}", "-lXfont2"
    system "./test"
  end
end
