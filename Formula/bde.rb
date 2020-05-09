class Bde < Formula
  desc "Basic Development Environment: foundational C++ libraries used at Bloomberg"
  homepage "https://github.com/bloomberg/bde"
  url "https://github.com/bloomberg/bde/archive/3.54.1.0.tar.gz"
  sha256 "d157050476b869d68fcf9abb4bfa05f018d633e5be91b35a7572ead7def76cee"

  bottle do
    cellar :any_skip_relocation
    sha256 "d3abf15f4e9d53b97063585e96b6da8f168828c26094ff83f27f65cf165290c7" => :catalina
    sha256 "4e11a431848f3ffc2edcf96c84cdf59b41d4a3e6096fd309bd3bf2d16aa2d84d" => :mojave
    sha256 "b07114979f7d01848ebd10fe2cd1c904e734dcf602007d0bb8dc1d72fe87549b" => :high_sierra
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
