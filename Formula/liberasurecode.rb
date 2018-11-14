class Liberasurecode < Formula
  desc "Erasure Code API library written in C with pluggable backends"
  homepage "https://github.com/openstack/liberasurecode"
  url "https://github.com/openstack/liberasurecode/archive/1.6.0.tar.gz"
  sha256 "37f36f49f302a47253c7756e13fd7d28028542efbad5acadbf432c1a55a7e085"

  bottle do
    cellar :any
    sha256 "8d5dacaeb9bd0cbbb8fbdb73349e48dec6bd2ff4adcdf908a0cc7eb4f9ec0ea2" => :mojave
    sha256 "2a634bd0e0e2e48044804e977525d256cd4c649f143256aa6b9804cc72014dc4" => :high_sierra
    sha256 "ceda0bdef7f84490a8b9afa435150e1b11e67d896d70463d605095b042d52dc7" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "jerasure"

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
