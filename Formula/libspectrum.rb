class Libspectrum < Formula
  desc "Support library for ZX Spectrum emulator"
  homepage "https://fuse-emulator.sourceforge.io/libspectrum.php"
  url "https://downloads.sourceforge.net/project/fuse-emulator/libspectrum/1.4.4/libspectrum-1.4.4.tar.gz"
  sha256 "fdfb2b2bad17bcfc98c098deaebf2a9811824b08d525172436d5eb134c9780b1"
  revision 1

  bottle do
    cellar :any
    sha256 "c4e70d37db34db4b4ab5ced6cb72e7860a2b362f107628a4c5a157428028a0b6" => :mojave
    sha256 "42b63148fa851319db8dc6fe70c7895c84a64c6071f05a0791f87b08ce1c55a1" => :high_sierra
    sha256 "185c851d42b802b2b021ef00afac4e1f07a6ab6bd29d3b5ca4c7bef65f4b8cc9" => :sierra
  end

  head do
    url "https://svn.code.sf.net/p/fuse-emulator/code/trunk/libspectrum"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "audiofile"
  depends_on "glib"
  depends_on "libgcrypt"

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
