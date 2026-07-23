class Libxfont2 < Formula
  desc "X11 font rasterisation library"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/lib/libXfont2-2.0.8.tar.gz"
  sha256 "a53d621b6ceb1dcbd05a0b9bd7f13c34efa40401cd5c05af904035c567a30f18"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "190cb605ee09f84a9632c26d17706c6893a18df375330869075da978d7947c3d"
    sha256 cellar: :any, arm64_sequoia: "7be38e82d7ed64498732ca445afddb877c24f1725be0c4edb9cc76869f8dfa48"
    sha256 cellar: :any, arm64_sonoma:  "04c52f143c9c9b5ac9532297320c988a1763d877ca3775db693f2abb7dcb83f0"
    sha256 cellar: :any, sonoma:        "98f14fd036d09a063fbc6f6f078f2df115d92a9591cb650cb620b9683878ee4f"
    sha256 cellar: :any, arm64_linux:   "b721287d822f7f4184416cc818074e7ecd4eedaddb286401c1120f99ec3c7382"
    sha256 cellar: :any, x86_64_linux:  "54c78cb64cca263303ecebc776d124e63d6d10b66e129020c151c6f5723790a6"
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
