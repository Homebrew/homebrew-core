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
    sha256 cellar: :any,                 arm64_sequoia: "8562d5a43bac7a9e4e615d0ba4bb72b8d1cebdf52a1b92f924f7358b587d139d"
    sha256 cellar: :any,                 arm64_sonoma:  "90bc1ab8734f27d41ceaeadc9e999de4c18766cf4b62e8fed1449dc828ea2395"
    sha256 cellar: :any,                 arm64_ventura: "7276c94db8b9a550cb79d37a97fd0d3a64765399640d9d37b791b4aa3b3a2341"
    sha256 cellar: :any,                 sonoma:        "746c2b4389ee7163e708c081ee1b967c60bb28a7d46fe8883f4798f137e897a0"
    sha256 cellar: :any,                 ventura:       "84ecc0430f40983d58c2c8cb2107846b2a20d99d9f089c27464b97260e3091d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95966f571ddb04072257468f8545c9204a1aee180015a9f6c44db8113e57f060"
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
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <tiffio.h>

      int main(int argc, char* argv[])
      {
        TIFF *out = TIFFOpen(argv[1], "w");
        TIFFSetField(out, TIFFTAG_IMAGEWIDTH, (uint32) 10);
        TIFFClose(out);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ltiff", "-o", "test"
    system "./test", "test.tif"
    assert_match(/ImageWidth.*10/, shell_output("#{bin}/tiffdump test.tif"))
  end
end
