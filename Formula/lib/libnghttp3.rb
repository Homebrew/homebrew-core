class Libnghttp3 < Formula
  desc "HTTP/3 library written in C"
  homepage "https://nghttp2.org/nghttp3/"
  url "https://github.com/ngtcp2/nghttp3/releases/download/v1.13.1/nghttp3-1.13.1.tar.xz"
  mirror "http://fresh-center.net/linux/www/nghttp3-1.13.1.tar.xz"
  sha256 "020836668c711d5c166969f8b165fbfd989e6967d0601947bf608f29e2158518"
  license "MIT"
  head "https://github.com/ngtcp2/nghttp3.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "320e1c20068e3e7204c56c681059c39c8e50dae2d4ca0392b2f2d7cf3fbfa836"
    sha256 cellar: :any,                 arm64_sequoia: "f9f65dc7521b2c63109c3fbc7f2b062a0d8b0359951d7ba0f509037eb5a8531d"
    sha256 cellar: :any,                 arm64_sonoma:  "9ad58bd871acdd9e73eeeda3775905ea697ac59d397cfd261428ab9fd6bea167"
    sha256 cellar: :any,                 sonoma:        "964265e59252df3deea3c5b723985298a0a6ca3736632e062cf670822b17f876"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0544b65721cadcfdb3a06f05e77e39895a388ffc03dac064f459d978127713a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e438bfe31c50fea2319aa355e9ee4c1f4a244aab07ee9784144db9434e1e8566"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DENABLE_LIB_ONLY=1", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <nghttp3/nghttp3.h>

      int main(void) {
        nghttp3_qpack_decoder *decoder;
        if (nghttp3_qpack_decoder_new(&decoder, 4096, 0, nghttp3_mem_default()) != 0) {
          return 1;
        }
        nghttp3_qpack_decoder_del(decoder);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lnghttp3"
    system "./test"
  end
end
