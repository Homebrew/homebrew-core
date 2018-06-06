class Libspectrum < Formula
  desc "Support library for ZX Spectrum emulator"
  homepage "https://fuse-emulator.sourceforge.io/libspectrum.php"
  url "https://downloads.sourceforge.net/project/fuse-emulator/libspectrum/1.4.3/libspectrum-1.4.3.tar.gz"
  sha256 "e1f9d7b2c12643bdf97092bc5c4bf6cd11b786ad94a154521cf697b9e9d4752d"

  bottle do
    cellar :any
    sha256 "d0bee26018c732ae972b9c0c31202d0ecd055840375f42db57de0b593161fdef" => :high_sierra
    sha256 "69cb2bf24f635320a2d3bfd57a88a40553decdb3bcdc4ff30f3d0db212285361" => :sierra
    sha256 "946c2487b9542dd825ad6b3a477f0478f88b83df9d47f14ea272fbb97b6e35ab" => :el_capitan
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
