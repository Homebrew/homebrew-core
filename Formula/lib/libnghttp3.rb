class Libnghttp3 < Formula
  desc "HTTP/3 library written in C"
  homepage "https://nghttp2.org/nghttp3/"
  url "https://github.com/ngtcp2/nghttp3.git",
      tag:      "v1.7.0",
      revision: "86a72e9e64b81c770315636da8756d3ce38c3281"
  license "MIT"
  head "https://github.com/ngtcp2/nghttp3.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a3c8f4658539e92c32f790e6e122c5cd5997a0f9ab9e80cbacff9e8a0f5ef848"
    sha256 cellar: :any,                 arm64_sonoma:  "6734dfc0f8d258a6166568635fed6c31dfb1e91a60be440bb92a6ec5e7b2f113"
    sha256 cellar: :any,                 arm64_ventura: "5249a29504d61bdd324202e585ab20a3469141f53c33bf9675593de70f19bd79"
    sha256 cellar: :any,                 sonoma:        "957808bd55a7e1f592af84b989a3b32daf67f15a16ff3661f92721b65aa13949"
    sha256 cellar: :any,                 ventura:       "cb3120a35a4f927550f0c0425599d18578bd55819cb8abb2c4955d7da1cecc5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8c3f3addc09b45d718a445ed1a1ce9fbe68777b31abcba543a7a68c654f6f60"
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
