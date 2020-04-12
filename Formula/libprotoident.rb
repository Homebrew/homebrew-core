class Libprotoident < Formula
  desc "Performs application layer protocol identification for flows"
  homepage "https://research.wand.net.nz/software/libprotoident.php"
  url "https://research.wand.net.nz/software/libprotoident/libprotoident-2.0.13.tar.gz"
  sha256 "8ca7ccd95b3f23457c3f9eff480364565b553bbcab9b39969f964910738e5672"
  revision 1

  bottle do
    cellar :any
    sha256 "8db46b2b98a50a616d8f1820defead65ffaf5ba5c01b8480858395b64d45f5b6" => :catalina
    sha256 "1143ffb528f58cf2ae55cf461fad927bf91ef14125dc2b9cbfbcefae908a96d9" => :mojave
    sha256 "4305f7265ff0343178f0f6019889878c299a1e55a8aaac14c1382445aa0ac600" => :high_sierra
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
