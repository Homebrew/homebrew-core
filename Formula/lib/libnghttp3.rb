class Libnghttp3 < Formula
  desc "HTTP/3 library written in C"
  homepage "https://nghttp2.org/nghttp3/"
  url "https://github.com/ngtcp2/nghttp3/releases/download/v1.12.0/nghttp3-1.12.0.tar.xz"
  mirror "http://fresh-center.net/linux/www/nghttp3-1.12.0.tar.xz"
  sha256 "6ca1e523b7edd75c02502f2bcf961125c25577e29405479016589c5da48fc43d"
  license "MIT"
  head "https://github.com/ngtcp2/nghttp3.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e284d356865af5e93210253ef973a4f90692b560627eba68e54cf47527a386a5"
    sha256 cellar: :any,                 arm64_sequoia: "1eb2c780340d21a766a0e7f4a7f2ae330377340d8a272fa0ad5d144ca709cca5"
    sha256 cellar: :any,                 arm64_sonoma:  "9ca811ccb32e85dacdf552d23f3fb461cd7892408cd9db5cf8ba71229ddd3e8c"
    sha256 cellar: :any,                 sonoma:        "81311931d8acb0cb2cb216c87bb17c9fe2abb19bff1edcf35436d75b0997f06c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55a4b0298d894b1a45f56c3480a1368b58333a04f2ab97cbd64f434c7c89d798"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a58df7a8c2219f36db9057662b7d1fd5ee6ef345839b51e168ade2396514b291"
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
