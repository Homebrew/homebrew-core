class Libnghttp3 < Formula
  desc "HTTP/3 library written in C"
  homepage "https://nghttp2.org/nghttp3/"
  url "https://github.com/ngtcp2/nghttp3.git",
      tag:      "v1.7.0",
      revision: "86a72e9e64b81c770315636da8756d3ce38c3281"
  license "MIT"
  head "https://github.com/ngtcp2/nghttp3.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5b790a23a40c6afdfbefeaa1cd8277f6fb697df9ee258fddd0314f2a98e381ae"
    sha256 cellar: :any,                 arm64_sonoma:  "6f2200eb626ea9eaa4cee07e940a56acfbf3c359b8a226efd76dcc222e211810"
    sha256 cellar: :any,                 arm64_ventura: "b71c4bd746cefe0e97aef0a0f2135bc62d169b97c05fb03c8ab0e9ed2edba6c5"
    sha256 cellar: :any,                 sonoma:        "ad8d24ef80ab33d089942e6d3ddbcc8a9576df6edf5b58d07c5bbe4a279dd2aa"
    sha256 cellar: :any,                 ventura:       "c7562b4061978560cd58afc29f48bcbf5c4ea44e9c3b3483226e159a87482daa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ad6a04daa0150fc54a7df2cfcb4de68ce55d343cb4f0bc22340244997abb50f"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test

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

    flags = shell_output("pkgconf --cflags --libs libnghttp3").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
