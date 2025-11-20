class Libxfont2 < Formula
  desc "X11 font rasterisation library"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/lib/libXfont2-2.0.7.tar.gz"
  sha256 "90b331c2fd2d0420767c4652e007d054c97a3f03a88c55e3b986bd3acfd7e338"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "f84c9f3936c3d9dd694e0dee4ba95df511a20845cacd570774700c9d0cc5eea6"
    sha256 cellar: :any,                 arm64_sequoia:  "692143371069bb49c4db0055757354b42f2475b34339c0617ec4f1fa92db8e73"
    sha256 cellar: :any,                 arm64_sonoma:   "e33dc088fa4e022dd975f35be2e3f9c6d6f431e8d7b8aa17b6f7e3f2b5db1448"
    sha256 cellar: :any,                 arm64_ventura:  "2857c874fab6fa57a282960550eeeaf8e5d2cdb36533bb64e313eb458e03dac4"
    sha256 cellar: :any,                 arm64_monterey: "663b13f5a8beaaf145a6ef76ce3fa7320f6a0d07a3e7aa4ce07a9085d6d2e5da"
    sha256 cellar: :any,                 sonoma:         "59052815ebda654383a9c9d8169bac87e8185d8b6590bb3c1323379d1aa16306"
    sha256 cellar: :any,                 ventura:        "6a5489db0d7264a996eec1726eb2a2d990d1579af46708dfafe08d66c4937b45"
    sha256 cellar: :any,                 monterey:       "73b90f18a8c56a14ffe1c4e8194102865f1719bbf362d05231203ee179e75013"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b5b559d35ae934e89ce10273910623dd767c8bc2ca5bfb6c5b6bf99c26ec613e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1290f56a9f831c1a2c8d8765bc300519e448bc334d6a156061cc5e05162a3c5f"
  end

  depends_on "pkgconf" => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto" => [:build, :test]
  depends_on "xtrans" => :build

  depends_on "freetype"
  depends_on "libfontenc"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

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
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
