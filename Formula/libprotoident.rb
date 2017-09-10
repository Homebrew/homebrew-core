class Libprotoident < Formula
  desc "Performs application layer protocol identification for flows"
  homepage "https://research.wand.net.nz/software/libprotoident.php"
  url "https://research.wand.net.nz/software/libprotoident/libprotoident-2.0.11.tar.gz"
  sha256 "796d59ec0a48ee88d386d4f0a393a80df01184a92bbbb8c2aa2e2fc10741840a"

  bottle do
    cellar :any
    sha256 "a3f30f045066ca4b054a23a696be4b7ff083fc9895cc1e13b220d522351a6864" => :sierra
    sha256 "3f81b44c4ed331a9d3e1bda531bf4d3a38f3bbe29d266a7d6a49608b80b52a5b" => :el_capitan
    sha256 "efbc7daba7362f5339c477a314d428189b4b7db05352086b9fd3737134e96b8a" => :yosemite
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
