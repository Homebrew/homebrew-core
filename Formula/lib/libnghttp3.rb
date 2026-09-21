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
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "b04718068d48592d75eac39237bc5c792313ac1bf267bf5a4c91f26c45aa45b1"
    sha256 cellar: :any, arm64_tahoe:       "f06612abad603898100dfc4fdcff8464789a2b57593ec70255ed633d664020e7"
    sha256 cellar: :any, arm64_sequoia:     "f0c56bcde3273d2599455d0ab18a281d6a329d63af4672fdbdf3f07633276475"
    sha256 cellar: :any, arm64_linux:       "aabb9a105e6abaef3fb08330986306c71ff1716ff27a5edc29963b9279134657"
    sha256 cellar: :any, x86_64_linux:      "70585a5cc3fd09d477862550303e6d356361da783605bc6854ac556be5047512"
  end

  depends_on "cmake" => :build

  deny_network_access!

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
