class Libtiff < Formula
  desc "TIFF library and utilities"
  homepage "https://libtiff.gitlab.io/libtiff/"
  url "https://download.osgeo.org/libtiff/tiff-4.7.1.tar.gz"
  mirror "https://fossies.org/linux/misc/tiff-4.7.1.tar.gz"
  sha256 "f698d94f3103da8ca7438d84e0344e453fe0ba3b7486e04c5bf7a9a3fabe9b69"
  license "libtiff"

  livecheck do
    url "https://download.osgeo.org/libtiff/"
    regex(/href=.*?tiff[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5e387e46027338151f69315d0931c014689ab019f1ce3c3bb16d4a395925bb04"
    sha256 cellar: :any,                 arm64_sequoia: "e32b6017d70bb365933cc84df9b2db416ea6e3bcc1c57fad4903f7392b13c1a7"
    sha256 cellar: :any,                 arm64_sonoma:  "66b69d6252e56fbaf1e1e6e67316c4911cdd24838a924ec63e32628058d332ee"
    sha256 cellar: :any,                 sonoma:        "7291204d8680bf0bb9e484025e5d1bef48c696b9eb81a0b59476f6edb25f7f55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82c21a78de8644c3ef816838a96fb892b91cb86cfcec1800fa120d68048f7f82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e563c83e94f568b644a41aae12c07439b1591d4cd9e6102c5062042b8ae2c9b1"
  end

  depends_on "jpeg-turbo"
  depends_on "xz"
  depends_on "zstd"
  uses_from_macos "zlib"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-libdeflate
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
