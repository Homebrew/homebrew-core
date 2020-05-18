class Bde < Formula
  desc "Basic Development Environment: foundational C++ libraries used at Bloomberg"
  homepage "https://github.com/bloomberg/bde"
  url "https://github.com/bloomberg/bde/archive/3.55.0.0.tar.gz"
  sha256 "fed51e427067b25f9d39a064026a6dc7718c244a4456c4169d5f572b3fee8a41"

  bottle do
    cellar :any_skip_relocation
    sha256 "43d51a6bc15681fa341ae48b96381f12830889906d68ae9a2f59897584a3746e" => :catalina
    sha256 "3222a847660e401e38df83a2d674b30460999991d320517972529cb8d578c5f3" => :mojave
    sha256 "a96b2ea04a958d1011ff02c93f1613c2894e81805782c29b6deffb3572d28303" => :high_sierra
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
