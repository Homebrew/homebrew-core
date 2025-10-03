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
    sha256 cellar: :any,                 arm64_tahoe:   "4ba66f9277e4e65f24a3ae2c88124b47022bbdcb79c26643ea5d1b334afb3486"
    sha256 cellar: :any,                 arm64_sequoia: "b77fbb41fbb1dc44fb16bbf0219b73ee64f7007fda3218fcac57798b49958f74"
    sha256 cellar: :any,                 arm64_sonoma:  "366a3c2192d027bf4678769b949d8d8c61881545a70fd10a5770c426428a92ad"
    sha256 cellar: :any,                 arm64_ventura: "f0ea275a48137990d39787f8d82f679170ee2d2d6fb01087e16f324c85c90874"
    sha256 cellar: :any,                 sonoma:        "5a556039d50589667e0571a46c0256821017e746512fd25b60de182259b61b54"
    sha256 cellar: :any,                 ventura:       "403e67b569a604c3df1c1e16e6be47d5e347716ba63da67107473be8b19dd124"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3387fd15ebd91d6cd96671c317bf76ef49e3d98b163e70c58813eb0e4e04d426"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9784c25d2ff756cf7dc147211e48a7ea321803cd9e8e6747709fd000488aaf66"
  end

  uses_from_macos "expat"
  uses_from_macos "zlib"

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
