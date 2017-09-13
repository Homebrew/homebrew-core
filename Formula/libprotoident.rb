class Libprotoident < Formula
  desc "Performs application layer protocol identification for flows"
  homepage "https://research.wand.net.nz/software/libprotoident.php"
  url "https://research.wand.net.nz/software/libprotoident/libprotoident-2.0.11.tar.gz"
  sha256 "796d59ec0a48ee88d386d4f0a393a80df01184a92bbbb8c2aa2e2fc10741840a"

  bottle do
    cellar :any
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
