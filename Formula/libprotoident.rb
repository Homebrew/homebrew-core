class Libprotoident < Formula
  desc "Performs application layer protocol identification for flows"
  homepage "https://research.wand.net.nz/software/libprotoident.php"
  url "https://research.wand.net.nz/software/libprotoident/libprotoident-2.0.13.tar.gz"
  sha256 "8ca7ccd95b3f23457c3f9eff480364565b553bbcab9b39969f964910738e5672"

  bottle do
    cellar :any
    sha256 "1b68bd65266f6d2eedf238579d25abd4be78bbdde83a4947bb9c66668c783505" => :mojave
    sha256 "48a4b98343c8a875dc429c11f0e65b2d4afbd66e631aa390deb71eca16dfc55d" => :high_sierra
    sha256 "e353b002c9c3180965daadadf13273ab2f74fc6ec4701ba99a8231aaf4e9e3e0" => :sierra
    sha256 "9a631567b1642854a7d8572f047cf4e02fff34bae11c43e7d91dbf16c0529a3b" => :el_capitan
  end

  depends_on "libflowmanager"
  depends_on "libtrace"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libprotoident.h>

      int main() {
        lpi_init_library();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lprotoident", "-o", "test"
    system "./test"
  end
end
