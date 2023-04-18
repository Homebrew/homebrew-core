class Libxfont2 < Formula
  desc "X11 font rasterisation library"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/lib/libXfont2-2.0.6.tar.gz"
  sha256 "a944df7b6837c8fa2067f6a5fc25d89b0acc4011cd0bc085106a03557fb502fc"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "841a2661ab9a5de3edc0d436d14802a811c495e4f7036b84da083ff6456da2df"
    sha256 cellar: :any,                 arm64_monterey: "b6ad688dc31a73b3a9bb5368bbf5624cf410007955cd3b2feb9ea1a663b7241c"
    sha256 cellar: :any,                 arm64_big_sur:  "3e7cd1603b33ffa074ad368ac277889ca8709bfda2ce03e222acb91ba90b4b7b"
    sha256 cellar: :any,                 ventura:        "f5b166780122300dc73a7e4154868f241dabaf3573de040bde4f2b2d9afb3399"
    sha256 cellar: :any,                 monterey:       "13ae077d69dc0a31de51d1ebac0ec9f5a6dcdcaff5685ea1904fd7057a56c936"
    sha256 cellar: :any,                 big_sur:        "945df3484eed14747271f4c8dded5e69a503352ac41d66d2a2c1873fb8b4395d"
    sha256 cellar: :any,                 catalina:       "425147217de1a857aba247b24c7f96c21239a459dd69fac469d0debc9feb42c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ae886e57074b44004d36a3025039506e45a126d5acf77e2b4c4df76e699c450"
  end

  depends_on "pkg-config"  => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto"   => [:build, :test]
  depends_on "xtrans"      => :build

  depends_on "freetype"
  depends_on "libfontenc"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    configure_args = std_configure_args + %w[
      --with-bzip2
      --enable-devel-docs=no
      --enable-snfformat
      --enable-unix-transport
      --enable-tcp-transport
      --enable-ipv6
      --enable-local-transport
    ]

    system "./configure", *configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stddef.h>
      #include <X11/fonts/fontstruct.h>
      #include <X11/fonts/libxfont2.h>

      int main(int argc, char* argv[]) {
        xfont2_init(NULL);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-o", "test",
      "-I#{include}", "-I#{Formula["xorgproto"].include}",
      "-L#{lib}", "-lXfont2"
    system "./test"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
