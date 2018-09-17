class Libspectrum < Formula
  desc "Support library for ZX Spectrum emulator"
  homepage "https://fuse-emulator.sourceforge.io/libspectrum.php"
  url "https://downloads.sourceforge.net/project/fuse-emulator/libspectrum/1.4.4/libspectrum-1.4.4.tar.gz"
  sha256 "fdfb2b2bad17bcfc98c098deaebf2a9811824b08d525172436d5eb134c9780b1"

  bottle do
    cellar :any
    sha256 "3a04dbf9a6c776ad1a80b69019f273456b743af711dc93332e70418fadbc6ed2" => :mojave
    sha256 "585a96b481bea5c5f15c4251134351a0a37fbc458b244514f7917f9451080d5a" => :high_sierra
    sha256 "a2107f7b764dea5b1726e7275f1810019420edaf144c8b451a3b8d70d253f5de" => :sierra
    sha256 "ca3aa9fb750d786bfbf2b9e74c8503d84459eee48b57bbb58a0359f0cff57b0c" => :el_capitan
  end

  head do
    url "http://svn.code.sf.net/p/fuse-emulator/code/trunk/libspectrum"
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
