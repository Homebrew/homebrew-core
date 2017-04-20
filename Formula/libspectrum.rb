class Libspectrum < Formula
  desc "Support library for ZX Spectrum emulator"
  homepage "https://fuse-emulator.sourceforge.io/libspectrum.php"
  url "https://downloads.sourceforge.net/project/fuse-emulator/libspectrum/1.3.2/libspectrum-1.3.2.tar.gz"
  sha256 "c7d7580097116a7afd90f1e3d000e4b7a66b20178503f11e03b3a95180208c3f"

  bottle do
    cellar :any
    sha256 "a953f5601490b156d17a325c5a9c802c920d0ec660e6f3a841e5c694e0fa9246" => :sierra
    sha256 "29573007d0467e7f9219e6cca7e85746785fcd24e907340abaa2a4afa51b8fcc" => :el_capitan
    sha256 "b1c1e2ffcccabd27c2a43fc8036952bcb5d46a915e64a6e8d1e0f86265455e20" => :yosemite
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
    (testpath/"test.c").write <<-EOS.undent
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
