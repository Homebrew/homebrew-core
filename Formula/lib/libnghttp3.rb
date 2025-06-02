class Libnghttp3 < Formula
  desc "HTTP/3 library written in C"
  homepage "https://nghttp2.org/nghttp3/"
  url "https://github.com/ngtcp2/nghttp3.git",
      tag:      "v1.10.1",
      revision: "df0d504b60a2600f57ab300ca2b61f64905e7d15"
  license "MIT"
  head "https://github.com/ngtcp2/nghttp3.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2ebf1020cf541ed3cdc0a98275e64c2818fe74663738f19a0ebcd062723d7fbb"
    sha256 cellar: :any,                 arm64_sonoma:  "51b211c4d7915aea0fae36b10e6b0334954beec857400f5aad1fcafdb17f9a5e"
    sha256 cellar: :any,                 arm64_ventura: "40c0ddc700e103399e2dce15383cb1ef9b36d764377397a651ebf7d209c002a4"
    sha256 cellar: :any,                 sonoma:        "be2f473cf2ffe30edc3c7ba3f59e32e1a6d67f254bb2d19dda22c13eb96ea5bc"
    sha256 cellar: :any,                 ventura:       "d3453fa790c09ffa53c4d863622c64d17c81354be9e530801e5772822f5fd504"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0199ab5fd4532235e171b06e22039752482b30338ba806b205a886d15c636a6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b295fd69e203884fd9c47470612eccf280fa708cfab9af9b23f82ac3f301af7"
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
