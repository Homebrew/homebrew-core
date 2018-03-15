class Libspectrum < Formula
  desc "Support library for ZX Spectrum emulator"
  homepage "https://fuse-emulator.sourceforge.io/libspectrum.php"
  url "https://downloads.sourceforge.net/project/fuse-emulator/libspectrum/1.4.1/libspectrum-1.4.1.tar.gz"
  sha256 "025a1663491cc58174e91df77d82b28782310f6831485cb14291ce774f23c729"

  bottle do
    cellar :any
    sha256 "345eb34fea01e4c8c56ebd6cf9760212f2824128994d36ed54101ae1a7ea8ede" => :high_sierra
    sha256 "3a73d20585d1bcfd63cd22cf875ffd5d7ef00f7edf72117beefaca8886be8da4" => :sierra
    sha256 "ae0fef62ab3cbfc4f53a69203c517b217016c2bfd76edfeea66cdbbcf7915c8c" => :el_capitan
  end

  head do
    url "https://svn.code.sf.net/p/fuse-emulator/code/trunk/libspectrum"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libgcrypt" => :recommended
  depends_on "glib" => :recommended
  depends_on "audiofile" => :recommended

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "libspectrum.h"
      #include <assert.h>

      int main() {
        assert(libspectrum_init() == LIBSPECTRUM_ERROR_NONE);
        assert(strcmp(libspectrum_version(), "#{version}") == 0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lspectrum", "-o", "test"
    system "./test"
  end
end
