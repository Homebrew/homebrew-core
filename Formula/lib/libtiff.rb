class Libtiff < Formula
  desc "TIFF library and utilities"
  homepage "https://libtiff.gitlab.io/libtiff/"
  url "https://download.osgeo.org/libtiff/tiff-4.7.1.tar.gz"
  mirror "https://fossies.org/linux/misc/tiff-4.7.1.tar.gz"
  sha256 "f698d94f3103da8ca7438d84e0344e453fe0ba3b7486e04c5bf7a9a3fabe9b69"
  license "libtiff"
  revision 1

  livecheck do
    url "https://download.osgeo.org/libtiff/"
    regex(/href=.*?tiff[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e93670ed1f7f484d164a8755767cd55741559db7c402d7d55d1bdf6da87d5f67"
    sha256 cellar: :any,                 arm64_sequoia: "68bf2bc8fa5ce10a32b70b2b402245c89dcc875413ed92981a024c8510d3cb9a"
    sha256 cellar: :any,                 arm64_sonoma:  "c4458243f3615e82755fdec34041ccef27b13d20df1d867f99d876d34e7a627a"
    sha256 cellar: :any,                 sonoma:        "9061b4453709aa2144d6c84bad4dbf0846d507eaa52a3016079822855078ba3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c1b199256ee763eaf5bbf47376900c08d37480472aa5456294bfb3b1e967bd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2548f1c935d423641faded7ab2539f04756dd7765de31e179854d2dcf84093b"
  end

  depends_on "jpeg-turbo"
  depends_on "xz"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %W[
      --disable-libdeflate
      --disable-webp
      --enable-zstd
      --enable-lzma
      --with-jpeg-include-dir=#{Formula["jpeg-turbo"].opt_include}
      --with-jpeg-lib-dir=#{Formula["jpeg-turbo"].opt_lib}
      --without-x
    ]
    system "./configure", *args, *std_configure_args
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
