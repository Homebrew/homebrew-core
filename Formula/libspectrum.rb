class Libspectrum < Formula
  desc "Support library for ZX Spectrum emulator"
  homepage "https://fuse-emulator.sourceforge.io/libspectrum.php"
  url "https://downloads.sourceforge.net/project/fuse-emulator/libspectrum/1.4.3/libspectrum-1.4.3.tar.gz"
  sha256 "e1f9d7b2c12643bdf97092bc5c4bf6cd11b786ad94a154521cf697b9e9d4752d"

  bottle do
    cellar :any
    sha256 "aeb19fe1f21beeb54235b2396e62088ef43eecbf0032b1945ceca771b6127903" => :high_sierra
    sha256 "ab582df473e55090086a0de7d657b7cae4b11522363735db444fa0dfc0f8b02a" => :sierra
    sha256 "67351fba529a5bba07450984de741a6f1f794ee493e62cd434ae05aa9ed5be6b" => :el_capitan
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
