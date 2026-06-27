class Libnghttp3 < Formula
  desc "HTTP/3 library written in C"
  homepage "https://nghttp2.org/nghttp3/"
  url "https://github.com/ngtcp2/nghttp3/releases/download/v1.16.0/nghttp3-1.16.0.tar.xz"
  mirror "http://fresh-center.net/linux/www/nghttp3-1.16.0.tar.xz"
  sha256 "776f59a99905c9a348846807b2e5ac9bb3485fc0f8c0250ba803018d5238a16e"
  license "MIT"
  compatibility_version 1
  head "https://github.com/ngtcp2/nghttp3.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "772d72a87a7e8b71d1f088180059ab96654cd56acd4e121ae4e2925aba0f09d8"
    sha256 cellar: :any, arm64_sequoia: "884f76eb493310492dbd50f3f331637e6f82904c9cf40244149f8b43e1ad7381"
    sha256 cellar: :any, arm64_sonoma:  "bc258aa321f040002529543aa980a6b4b5c9fe5c4992ebb5a16ffe251214fe7b"
    sha256 cellar: :any, sonoma:        "ec58e60d0f633355ad595ff7cee87bc1874b973a54842525ef6cc209cb9b5818"
    sha256 cellar: :any, arm64_linux:   "20b22937ccd9cb8c6c0ccbd4066b5a9dcc5c43adbd78854133b62b030dfe376a"
    sha256 cellar: :any, x86_64_linux:  "2db7779c13d68dde7683120d0202a12fb62e15f5c7d5f11190ce56994bdc594b"
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
