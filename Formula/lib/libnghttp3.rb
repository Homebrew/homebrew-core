class Libnghttp3 < Formula
  desc "HTTP/3 library written in C"
  homepage "https://nghttp2.org/nghttp3/"
  url "https://github.com/ngtcp2/nghttp3/releases/download/v1.18.0/nghttp3-1.18.0.tar.xz"
  mirror "http://fresh-center.net/linux/www/nghttp3-1.18.0.tar.xz"
  sha256 "aad782c23d3f01bd4bb52c8bac7a553b631ef8115fd1612703df6183449fef19"
  license "MIT"
  compatibility_version 1
  head "https://github.com/ngtcp2/nghttp3.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "896929daeacaf435ed2a119156d648526ee7ab83394f50f207b5a4dda376025a"
    sha256 cellar: :any, arm64_sequoia: "7d805c2219e1473377ac0d7b6ba6465d278ad016e71a535d9c89308c4e7f95fd"
    sha256 cellar: :any, arm64_sonoma:  "47258af952ff526bd115d4c7973186487ba21cafbe2b4d48082be6309fc26781"
    sha256 cellar: :any, sonoma:        "f7166812a06ced8bae92fa85019699d74084574149271030ba3cfbc329b6cbe0"
    sha256 cellar: :any, arm64_linux:   "36ede951ed147d201e0012f6084fb41ef52f46731c111511b8ae2710996f1fd1"
    sha256 cellar: :any, x86_64_linux:  "23d4c3f5d3b91b6fab9f77b66e96484ba9c389a88768e3d792037cbf2c46c2e4"
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
