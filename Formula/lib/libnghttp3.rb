class Libnghttp3 < Formula
  desc "HTTP/3 library written in C"
  homepage "https://nghttp2.org/nghttp3/"
  url "https://github.com/ngtcp2/nghttp3/releases/download/v1.17.0/nghttp3-1.17.0.tar.xz"
  mirror "http://fresh-center.net/linux/www/nghttp3-1.17.0.tar.xz"
  sha256 "e8b798272b9282045cb83577dcf7bd7fcd22bb3a43aec0eb1a24f675b4cef0b8"
  license "MIT"
  compatibility_version 1
  head "https://github.com/ngtcp2/nghttp3.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1acc6f9318f853f1fc4d7c5f7f6ebb0c759c6a4ab6c200db30b8ea4beae8525a"
    sha256 cellar: :any, arm64_sequoia: "1d42f9ea9932747c419026705966c81a2e6a19901f513777e959d320c09df162"
    sha256 cellar: :any, arm64_sonoma:  "ee90ca5ffb5eea7f02fdc70fdf8ba2fc0c5b5d7365f32b1c3469274042015337"
    sha256 cellar: :any, sonoma:        "bcd234c40a15e15c045a90f18a765a38dd4ea272819c9075a236fb5a2d14c084"
    sha256 cellar: :any, arm64_linux:   "5b427388e61d712c177369d758c8f5fb618f1539ecca1b6c34354352b89b8db2"
    sha256 cellar: :any, x86_64_linux:  "3a11e082441a81eb2f3d6f96a77fcfa0889c847c4574fee548b47ad469dc11b1"
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
