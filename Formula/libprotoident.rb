class Libprotoident < Formula
  desc "Performs application layer protocol identification for flows"
  homepage "https://research.wand.net.nz/software/libprotoident.php"
  url "https://research.wand.net.nz/software/libprotoident/libprotoident-2.0.12.tar.gz"
  sha256 "c09aba4882837c7f9ebf4ad153b637a9a7cbd5a2b4b398e10ddb63e74f270fac"

  bottle do
    cellar :any
    sha256 "de6d22071dfff2328803702a0e8b95a7526837631431c3bd77947102d912f5f0" => :high_sierra
    sha256 "d0607c24e1afbbbea7fdc95a2ea5e03db370c9d75e4bebceb545896cadf36dc7" => :sierra
    sha256 "76cc66a2a7e2b312f31388ddbcc8bf0cb952ee402e7e899b0dc50e7d4761c3a0" => :el_capitan
  end

  depends_on "libtrace"
  depends_on "libflowmanager"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
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
