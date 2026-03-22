class Exempi < Formula
  desc "Library to parse XMP metadata"
  homepage "https://libopenraw.freedesktop.org/exempi/"
  url "https://libopenraw.freedesktop.org/download/exempi-2.6.6.tar.bz2"
  sha256 "7513b7e42c3bd90a58d77d938c60d2e87c68f81646e7cb8b12d71fe334391c6f"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?exempi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "f9404d65e273a1db86e861cf3cec91b90d84e6f9cf730b16be039e7e9e9fd9f7"
    sha256 cellar: :any,                 arm64_sequoia: "119f156a24d54cf6fd5ebfea60608d8adadf7d9631e6b98d32d281279fb75331"
    sha256 cellar: :any,                 arm64_sonoma:  "241cb93b16ae12e70f8a584a492e8cb3f521fa73187065dc2e66b097d46ff073"
    sha256 cellar: :any,                 sonoma:        "65bc8dfd34b2c7b532169e0fbb76a26b336a4f1df99047c9ecfb1c2d25807c3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1fb6ef14d4db41974af4a667624c9222ac33f7fbb7c046d636fc324da4d2aff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6abf2c8aca5a4756a7fa4514260d7fbe7efc715550ea806eaf9c1290cde06f73"
  end

  uses_from_macos "expat"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--disable-silent-rules", "--disable-unittest", *std_configure_args
    system "make", "install"
  end

  test do
    cp test_fixtures("test.jpg"), testpath

    (testpath/"test.cpp").write <<~CPP
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
    CPP

    system ENV.cxx, "test.cpp", "-o", "test", "-I#{include}/exempi-2.0", "-L#{lib}", "-lexempi"
    system "./test"
  end
end
