class Libtiff < Formula
  desc "TIFF library and utilities"
  homepage "https://libtiff.gitlab.io/libtiff/"
  url "https://download.osgeo.org/libtiff/tiff-4.0.10.tar.gz"
  mirror "https://fossies.org/linux/misc/tiff-4.0.10.tar.gz"
  sha256 "2c52d11ccaf767457db0c46795d9c7d1a8d8f76f68b0b800a3dfe45786b996e4"
  revision 1

  bottle do
    cellar :any
    sha256 "c10014ad788ce996f4cd76f8f89acf1f957d59bb48424987ded2162ec6a69cec" => :catalina
    sha256 "6ecdca6159e5e4db0ec0fcbddbc76dbdc65e496139b131a05f2a9ed8187914f8" => :mojave
    sha256 "f05323c49236328f4a63e0acb9ff340baf37e589cf5699f334d1e98928f87fd4" => :high_sierra
    sha256 "818a699c6a293cccfbae8c8b1d0320c0fd8f7ca17c711fded8764f36d11a3db6" => :sierra
  end

  depends_on "jpeg"

  # Patches are taken from latest Fedora package, which is currently
  # libtiff-4.0.10-2.fc30.src.rpm and whose changelog is available at
  # https://apps.fedoraproject.org/packages/libtiff/changelog/

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/d15e00544e7df009b5ad34f3b65351fc249092c0/libtiff/libtiff-CVE-2019-6128.patch"
    sha256 "dbec51f5bec722905288871e3d8aa3c41059a1ba322c1ac42ddc8d62646abc66"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-lzma
      --with-jpeg-include-dir=#{Formula["jpeg"].opt_include}
      --with-jpeg-lib-dir=#{Formula["jpeg"].opt_lib}
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
