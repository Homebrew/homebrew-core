class Bde < Formula
  desc "Basic Development Environment: foundational C++ libraries used at Bloomberg"
  homepage "https://github.com/bloomberg/bde"
  url "https://github.com/bloomberg/bde/archive/3.55.0.0.tar.gz"
  sha256 "fed51e427067b25f9d39a064026a6dc7718c244a4456c4169d5f572b3fee8a41"

  bottle do
    cellar :any_skip_relocation
    sha256 "2916078b47cd41082b69d1eb6912c093da8c6b4774dab89c30a90d71815df84e" => :catalina
    sha256 "adb3e9b12cc0811bdb5e18e2d792faa13e0c84dbebad9fa65ae2e8e51c99e810" => :mojave
    sha256 "4d9bb6baeacfec561fe2e8c1cb77f8dda9cbb32ddec7bc42b6038087192b0076" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  resource "bde-tools" do
    url "https://github.com/bloomberg/bde-tools/archive/v1.1.tar.gz"
    sha256 "c5d77d5e811e79f824816ee06dbf92a2a7e3eb0b6d9f27088bcac8c06d930fd5"
  end

  def install
    buildpath.install resource("bde-tools")

    ENV.cxx11

    system "python", "./bin/waf", "configure", "--prefix=#{prefix}"
    system "python", "./bin/waf", "build"
    system "python", "./bin/waf", "install"
  end

  test do
    # bde tests are incredibly performance intensive
    # test below does a simple sanity check for linking against bsl.
    (testpath/"test.cpp").write <<~EOS
      #include <bsl/bsl_string.h>
      #include <bsl/bslma_default.h>
      int main() {
        using namespace BloombergLP;
        bsl::string string(bslma::Default::globalAllocator());
        return 0;
      }
    EOS
    system ENV.cxx, "-I#{include}/bsl", "test.cpp", "-L#{lib}", "-lbsl", "-o", "test"
    system "./test"
  end
end
