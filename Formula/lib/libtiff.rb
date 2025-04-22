class Libtiff < Formula
  desc "TIFF library and utilities"
  homepage "https://libtiff.gitlab.io/libtiff/"
  url "https://download.osgeo.org/libtiff/tiff-4.7.0.tar.gz"
  mirror "https://fossies.org/linux/misc/tiff-4.7.0.tar.gz"
  sha256 "67160e3457365ab96c5b3286a0903aa6e78bdc44c4bc737d2e486bcecb6ba976"
  license "libtiff"

  livecheck do
    url "https://download.osgeo.org/libtiff/"
    regex(/href=.*?tiff[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "5f771cedcb37119c3927c32d72589a66701db16fe3ef86b2daf9b87c3142b309"
    sha256 cellar: :any,                 arm64_sonoma:  "7400825c55ab3f7aef5c0571d59bd62ffc509a5252784c08034df07995cb9e71"
    sha256 cellar: :any,                 arm64_ventura: "b8952fb7bfabe979c42b9742cd959e5ba33bab2f8e44c536b9f5f6346190c33a"
    sha256 cellar: :any,                 sonoma:        "5610196cb9396c468513adc5bc7c4834a3f475ff6f3ebd98f77e3f8b2123da3e"
    sha256 cellar: :any,                 ventura:       "93fdbce17863cff383485295a955eae308f3bfc0f6b83d311645c5830a9964ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "befd41fd96bb263a78cdead93f8eff8320f911467bc4022add19150ec0b9d876"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e873d7ab4e4159cd3ee973a2ec9cf7530fa3679abb8968832269dd206dea6859"
  end

  depends_on "jpeg-turbo"
  depends_on "xz"
  depends_on "zstd"
  uses_from_macos "zlib"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-webp
      --enable-zstd
      --enable-lzma
      --with-jpeg-include-dir=#{Formula["jpeg-turbo"].opt_include}
      --with-jpeg-lib-dir=#{Formula["jpeg-turbo"].opt_lib}
      --without-x
    ]
    system "./configure", *args
    system "make", "install"

    # Avoid rebuilding dependents that hard-code the prefix.
    inreplace lib/"pkgconfig/libtiff-4.pc", prefix, opt_prefix
  end

  test do
    (testpath/"test.c").write <<~C
      #include <tiffio.h>

      int main(int argc, char* argv[])
      {
        TIFF *out = TIFFOpen(argv[1], "w");
        TIFFSetField(out, TIFFTAG_IMAGEWIDTH, (uint32) 10);
        TIFFClose(out);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-ltiff", "-o", "test"
    system "./test", "test.tif"
    assert_match(/ImageWidth.*10/, shell_output("#{bin}/tiffdump test.tif"))
  end
end
