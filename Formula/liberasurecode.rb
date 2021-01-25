class Liberasurecode < Formula
  desc "Erasure Code API library written in C with pluggable backends"
  homepage "https://github.com/openstack/liberasurecode"
  url "https://github.com/openstack/liberasurecode/archive/1.6.2.tar.gz"
  sha256 "f11752f41e652e62d0feb095a118a8fe1b5d43910d3d31a0de99b789070d7788"
  license "BSD-2-Clause"

  bottle do
    cellar :any
    sha256 "0252ffca75211c217bee75061bb6a62dc2982334b66d95fbfcdc2e686480d1fb" => :catalina
    sha256 "0073290d5c19d629b70f6e4be0677931f625e07e79d2dacea25b333f7d820933" => :mojave
    sha256 "2f0bb8a2f295cff0ba42097db3f31103f2f10637faa66ba2028bc746934b58d0" => :high_sierra
  end

  disable! date: "2020-12-08", because: "Depends on gf-complete which has been disabled"

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
    system ENV.cxx, "liberasurecode-test.cpp", "-L#{lib}", "-lerasurecode",
                    "-I#{include}/liberasurecode", "-o", "liberasurecode-test"
    system "./liberasurecode-test"
  end
end
