class Exempi < Formula
  desc "Library to parse XMP metadata"
  homepage "https://wiki.freedesktop.org/libopenraw/Exempi/"
  url "https://libopenraw.freedesktop.org/download/exempi-2.6.5.tar.bz2"
  sha256 "e9f9a3d42bff73b5eb0f77ec22cd0163c3e21949cc414ad1f19a0465dde41ffe"
  license "BSD-3-Clause"

  livecheck do
    url "https://libopenraw.freedesktop.org/exempi/"
    regex(/href=.*?exempi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "e4a036c99bc1e87333deaecbd4d7fbaf08558b462acca4b295ed922505f31367"
    sha256 cellar: :any,                 arm64_sonoma:   "fffe2e2da9ff2117ed01b3055811aa6b3c0348f33ca7da88bed84bbab3345767"
    sha256 cellar: :any,                 arm64_ventura:  "f97b4edaedaf3346999176b2f790bee721e9684c4faba1fd6d8b4f95df5a512d"
    sha256 cellar: :any,                 arm64_monterey: "3ea8dc1aaca7c2c12bd2673bdcb73dcb4c6f8fb6a928c9369e4cfcad5841e302"
    sha256 cellar: :any,                 sonoma:         "d4a92c827d8e702c9de91c44749c4448b611fea06b2a0cb444b505366e80f3f7"
    sha256 cellar: :any,                 ventura:        "ca6ef07fd6862b9148a8cabe608c0937f9da287638eec78d7402b29ba76c7fe2"
    sha256 cellar: :any,                 monterey:       "9595f29483fb85b894f482fd86221d791a02878bf5395638b63d90313abbf890"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30ae54f527539c8f605086923bb33cb44560cb84bca42c06ec052d74a894f14c"
  end

  uses_from_macos "expat"
  uses_from_macos "zlib"

  def install
    system "./configure", "--disable-silent-rules",
                          "--disable-unittest",
                          *std_configure_args
    system "make", "install"
  end

  test do
    cp test_fixtures("test.jpg"), testpath

    (testpath/"test.cpp").write <<~EOS
      #include <cassert>
      #include <exempi/xmp.h>
      #include <exempi/xmpconsts.h>

      int main() {
        const char *filename = "test.jpg";
        assert(xmp_init());
        assert(xmp_files_check_file_format(filename) == XMP_FT_JPEG);

        XmpFilePtr f = xmp_files_open_new(filename, XMP_OPEN_FORUPDATE);
        assert(f != NULL);
        XmpPtr xmp = xmp_files_get_new_xmp(f);
        assert(xmp != NULL);
        assert(xmp_files_can_put_xmp(f, xmp));

        assert(xmp_register_namespace(NS_CC, "cc", NULL));
        assert(xmp_set_property(xmp, NS_CC, "license", "Foo", 0));
        assert(xmp_files_put_xmp(f, xmp));

        assert(xmp_free(xmp));
        assert(xmp_files_close(f, XMP_CLOSE_SAFEUPDATE));
        xmp_terminate();
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-o", "test", "-I#{include}/exempi-2.0", "-L#{lib}", "-lexempi"
    system "./test"
  end
end
