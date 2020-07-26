class Bde < Formula
  desc "Basic Development Environment: foundational C++ libraries used at Bloomberg"
  homepage "https://github.com/bloomberg/bde"
  url "https://github.com/bloomberg/bde/archive/3.59.0.1.tar.gz"
  sha256 "ab8c41f7b7ebdbd3e0949a4a4521f34f7b08e1e8626b84158b5ad895d1abf689"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "97b0036ee6d7dac9f61bc17fe5db66c4fdd74eb2c672a71a9047d3f1b63335b0" => :catalina
    sha256 "41ede4a091088ca7c2189fb1f6891935bd3d871ff7519fbe9d63f2ab0e5ccc5d" => :mojave
    sha256 "2f0457b4628ee2ffb42b4be9c7a0208adfa47a9ec6ebbba1235933c317253716" => :high_sierra
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
