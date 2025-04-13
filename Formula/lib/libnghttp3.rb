class Libnghttp3 < Formula
  desc "HTTP/3 library written in C"
  homepage "https://nghttp2.org/nghttp3/"
  url "https://github.com/ngtcp2/nghttp3.git",
      tag:      "v1.8.0",
      revision: "96ad17fd71d599b78a11e0ff635eccb7d2f6d649"
  license "MIT"
  head "https://github.com/ngtcp2/nghttp3.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e2b468b3a671c66152cdffa3e7b12f15d56e9b3f85da0bbcc794e05607782612"
    sha256 cellar: :any,                 arm64_sonoma:  "f84d0a1ce59f1307bd86f97f1992688cb32b1adf82fe46407194b1f0baf028d9"
    sha256 cellar: :any,                 arm64_ventura: "9961791586720420ed53ce0f9c848574dd2a52ff1c6de6e86df634ad4f947a5f"
    sha256 cellar: :any,                 sonoma:        "4da00024ffb21953eaf885c1d16f070bdea28922f9757c8caa97e37ca5a24212"
    sha256 cellar: :any,                 ventura:       "5847cc1611cb01366f87a2f9b3821fe85ec1b56c281c4edf5034be2103bc1af7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bf6b0f19726f9a31f49919f998fbc4fec7ab0ee92c8d9673dd62c6fda1c832d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fadae98658ff0cbf5777fce0c4bc23e553e76ec2986766cb545066ac0a17ac4c"
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
