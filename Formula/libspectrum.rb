class Libspectrum < Formula
  desc "Support library for ZX Spectrum emulator"
  homepage "https://fuse-emulator.sourceforge.io/libspectrum.php"
  url "https://downloads.sourceforge.net/project/fuse-emulator/libspectrum/1.3.4/libspectrum-1.3.4.tar.gz"
  sha256 "1f4a92a8703fe9e6c3a995d324916ecb52e3281673b999ce3da2aaa4d67e8e5c"

  bottle do
    cellar :any
    sha256 "f3b397006c4fd43964c66f312dd1ecd41fe1e8faf8826f50fc9c6bb3a2e9188a" => :sierra
    sha256 "f7dd390b63d92d89e90cbdc1575df3732d1dd1fb780b916d25b747f4420931f4" => :el_capitan
    sha256 "03a6b48ae78fee04f022fd08a2f042c17485fa823eed6dbb5128a306d9b2dbb8" => :yosemite
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
