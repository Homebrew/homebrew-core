class Libspectrum < Formula
  desc "Support library for ZX Spectrum emulator"
  homepage "http://fuse-emulator.sourceforge.net/libspectrum.php"
  url "https://downloads.sourceforge.net/project/fuse-emulator/libspectrum/1.3.2/libspectrum-1.3.2.tar.gz"
  sha256 "c7d7580097116a7afd90f1e3d000e4b7a66b20178503f11e03b3a95180208c3f"

  bottle do
    cellar :any
    sha256 "dac41d17a30a8f9b4e65bfcd54ee684484fbfc5e86313cf3ace3f68aa41dbee5" => :sierra
    sha256 "19b8dbb3542c1b7c890083cbdd632e90382125876a2a35f9385f6658e9e25fca" => :el_capitan
    sha256 "f04142727815bb59686b49b34b0e0ebc1d9fb7f5061d80e2aaf24f4141e0569f" => :yosemite
  end

  head do
    url "http://svn.code.sf.net/p/fuse-emulator/code/trunk/libspectrum"
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
