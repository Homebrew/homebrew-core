class Liberasurecode < Formula
  desc "Erasure Code API library written in C with pluggable backends"
  homepage "https://github.com/openstack/liberasurecode"
  url "https://github.com/openstack/liberasurecode/archive/1.5.0.tar.gz"
  sha256 "713272e81e67f308c21fc6aad417f79b30fb1e7f2338293fa0eaadcc53611909"

  bottle do
    cellar :any
    sha256 "1dc03033d0359d6abeb0c183d38778f5f0f1280ff2423185783099c616ed7540" => :sierra
    sha256 "824ffcb696c9951aa380b6f5806a72573726b7026e0a051e7e6da8abcd542fc5" => :el_capitan
    sha256 "57683d16fd2dba4def2a9b6edd012aa35697dacd839ae1921b2ee4998dba1965" => :yosemite
    sha256 "f6b2d2aa09eb404e323634ae08aa413e7ca8db7a860cb2af43f58e4a3cd1a624" => :mavericks
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
    (testpath/"liberasurecode-test.cpp").write <<-EOS.undent
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
