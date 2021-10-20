class Leptonica < Formula
  desc "Image processing and image analysis library"
  homepage "http://www.leptonica.org/"
  url "http://www.leptonica.org/source/leptonica-1.82.0.tar.gz"
  sha256 "155302ee914668c27b6fe3ca9ff2da63b245f6d62f3061c8f27563774b8ae2d6"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.leptonica.org/download.html"
    regex(/href=.*?leptonica[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "f0d0cdb312ad51dc498f25765c7f4566e246eb7d74bd7ddc87b9a23f539f0bba"
    sha256 cellar: :any,                 big_sur:       "850aac10ef99d81dacea54d7b0f04df1a2058aac792b2649c4ecd91adcf1bbeb"
    sha256 cellar: :any,                 catalina:      "a758e0b2eb14c548dd87946193185784cdb8d868e0aa17b2426660fad6ecdab2"
    sha256 cellar: :any,                 mojave:        "8cef538c6bda97b6f8d71010259bced7ae5400f8a02e79e32cec1eee939b1463"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "118d4902ab8357da71a85d4461d460f1db63baed0d50bd717b145c3fd387f47d"
  end

  depends_on "pkg-config" => :build
  depends_on "giflib"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openjpeg"
  depends_on "webp"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-libwebp
      --with-libopenjpeg
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <leptonica/allheaders.h>

      int main(int argc, char **argv) {
          fprintf(stdout, "%d.%d.%d", LIBLEPT_MAJOR_VERSION, LIBLEPT_MINOR_VERSION, LIBLEPT_PATCH_VERSION);
          return 0;
      }
    EOS

    flags = ["-I#{include}/leptonica"] + ENV.cflags.to_s.split
    system ENV.cxx, "test.cpp", *flags
    assert_equal version.to_s, `./a.out`
  end
end
