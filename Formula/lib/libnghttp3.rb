class Libnghttp3 < Formula
  desc "HTTP/3 library written in C"
  homepage "https://nghttp2.org/nghttp3/"
  url "https://github.com/ngtcp2/nghttp3/releases/download/v1.15.0/nghttp3-1.15.0.tar.xz"
  mirror "http://fresh-center.net/linux/www/nghttp3-1.15.0.tar.xz"
  sha256 "6da0cd06b428d32a54c58137838505d9dc0371a900bb8070a46b29e1ceaf2e0f"
  license "MIT"
  head "https://github.com/ngtcp2/nghttp3.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "97ef00ffe4282cd24334ae030b8d9a822bfac20405fe9f31dae8b4f1e80b2133"
    sha256 cellar: :any,                 arm64_sequoia: "5b1b255e9791d2c78590f1914194765cbb87cb2a46cd2e52db5d741d0e86f070"
    sha256 cellar: :any,                 arm64_sonoma:  "379f36c4811ca6f8b170a79695480650720502759d34be52b403a99677fa5f07"
    sha256 cellar: :any,                 sonoma:        "8deca6fa2c6dc3f7ca526a4c5fa82a5d8bb7bc8b3fb49df1fc1ba03511ae57c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1aa2913d174e7defeccaa8ea7399c291f27bef7587092f5198e5ad81a3605cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16f16337f4028ce9c324bd3e9f1379791a1cdfe993e8e0374cfb6c262651d25b"
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
