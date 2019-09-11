class Libprotoident < Formula
  desc "Performs application layer protocol identification for flows"
  homepage "https://research.wand.net.nz/software/libprotoident.php"
  url "https://research.wand.net.nz/software/libprotoident/libprotoident-2.0.13.tar.gz"
  sha256 "8ca7ccd95b3f23457c3f9eff480364565b553bbcab9b39969f964910738e5672"

  bottle do
    cellar :any
    sha256 "b7e8f79111dad699a0219ce88740ef153fc1152a8090499e07a8cb8b354805d5" => :mojave
    sha256 "244ad5c441f10b9abe191108943b5d20601bfbb5ac3f245750230f3115472739" => :high_sierra
    sha256 "8de3bb257a10fd3c492606b643c78e808a2d1248fcf8ebc00525f7d0b50bb66e" => :sierra
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
