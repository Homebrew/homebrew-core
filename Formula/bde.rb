class Bde < Formula
  desc "Basic Development Environment: foundational C++ libraries used at Bloomberg"
  homepage "https://github.com/bloomberg/bde"
  url "https://github.com/bloomberg/bde/archive/3.60.0.1.tar.gz"
  sha256 "07dd91acf038014ef9985ed3466346119b058445f71aa34a2d618c6c534df07a"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "91b683a000a386f4d502fe46020b1e5ca362f3a35244e1e2dcd12397deb1df54" => :catalina
    sha256 "1b52a280a13506cabfeafdb14e39db0d1359677279e9a5d582b772321190c228" => :mojave
    sha256 "3fa5cca398b3805036cfa8579a781e7dd31e74d4acc56296d4024d856005978f" => :high_sierra
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
