class Bde < Formula
  desc "Basic Development Environment: foundational C++ libraries used at Bloomberg"
  homepage "https://github.com/bloomberg/bde"
  url "https://github.com/bloomberg/bde/archive/3.57.0.0.tar.gz"
  sha256 "68b456aebb6f0c532db221932a26730b01db5badca8dce99e10e3978930cafc2"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "03d49625918969176051584cda6d6b23e6a3049878dc946247360ab746b39c9e" => :catalina
    sha256 "16179163a52bd6dabf06e7709208496fdf3a7b845a679ebe44b7e492f8a772e3" => :mojave
    sha256 "1cbc01b6d179c35b560b8e2475cb2d7904f8b925cd3677988a9c3c2aaaa36492" => :high_sierra
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
