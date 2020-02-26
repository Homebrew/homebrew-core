class Liberasurecode < Formula
  desc "Erasure Code API library written in C with pluggable backends"
  homepage "https://github.com/openstack/liberasurecode"
  url "https://github.com/openstack/liberasurecode/archive/1.6.1.tar.gz"
  sha256 "958b01ff91efe7b21a19ca72937a93b2a5c7af41c08790d4fe9df82d8c5e24f0"

  bottle do
    cellar :any
    sha256 "f50f0786b554d9e619da955a98785a8ff6513bd4d244d80a37582a35a9f0adc9" => :catalina
    sha256 "fba6eb4f5a66f164cb2938a5a2981d4879915a225edefb4ff857910170e52e7a" => :mojave
    sha256 "7d96611a687605c4856d139d6b1c6305ed686587ee67683c7f3068fa6e5332b0" => :high_sierra
    sha256 "d7a79bb75e8f7c5099a453ec3a4c2dca8d78d3823101158be68f005e068311fc" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "jerasure"

  uses_from_macos "zlib"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"liberasurecode-test.cpp").write <<~EOS
      #include <erasurecode.h>

      int main() {
          /*
           * Assumes if you can create an erasurecode instance that
           * the library loads, relying on the library test suites
           * to test for correctness.
           */
          struct ec_args args = {
              .k  = 10,
              .m  = 5,
              .hd = 3
          };
          int ed = liberasurecode_instance_create(
                  EC_BACKEND_FLAT_XOR_HD,
                  &args
                  );

          if (ed <= 0) { exit(1); }
          liberasurecode_instance_destroy(ed);

          exit(0);
      }
    EOS
    system ENV.cxx, "liberasurecode-test.cpp", "-L#{lib}", "-lerasurecode", "-I#{include}/liberasurecode", "-o", "liberasurecode-test"
    system "./liberasurecode-test"
  end
end
