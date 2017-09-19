class Libspectrum < Formula
  desc "Support library for ZX Spectrum emulator"
  homepage "https://fuse-emulator.sourceforge.io/libspectrum.php"
  url "https://downloads.sourceforge.net/project/fuse-emulator/libspectrum/1.4.0/libspectrum-1.4.0.tar.gz"
  sha256 "6207d60e259fac2c2074b2149ff64914d656b658fb002d002a2be30bf0e6185f"

  bottle do
    cellar :any
    sha256 "4a821fef5a2f0d1be9fc1a73276cdb578ee63512c96435020e7c781217aa86aa" => :high_sierra
    sha256 "c1c4b1f1f249be03a88fb2cfac572d282baa58f4f74481d98b386d0e2b07c783" => :sierra
    sha256 "d05767dde2ea1f9f5b27b5f1944a57e479570dce88c0aadcf199844ec3a39455" => :el_capitan
    sha256 "c462c89b551d7556d971ad4db886853ba6feb39dd2ee3f4e0234131345563f6a" => :yosemite
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
