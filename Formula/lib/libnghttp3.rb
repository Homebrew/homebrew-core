class Libnghttp3 < Formula
  desc "HTTP/3 library written in C"
  homepage "https://nghttp2.org/nghttp3/"
  url "https://github.com/ngtcp2/nghttp3/releases/download/v1.19.0/nghttp3-1.19.0.tar.xz"
  mirror "http://fresh-center.net/linux/www/nghttp3-1.19.0.tar.xz"
  sha256 "228e17f5cc3d4de7bfced9912bd09de30e7f45741cc47503cf88d3fa9209e155"
  license "MIT"
  compatibility_version 1
  head "https://github.com/ngtcp2/nghttp3.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4aa61da9837c8773e8548bac1f6956446eb5babb5efa70ec02d3955cf7713f43"
    sha256 cellar: :any, arm64_tahoe:       "4d4260baf29ed38e74806c0e66a31e98af6e7afe4d66e0e9d29692d265751141"
    sha256 cellar: :any, arm64_sequoia:     "a7e6e8dadb7a218166d75d2849a7afec01588e27fb53fb18f11d3fce7f1ec853"
    sha256 cellar: :any, arm64_linux:       "3d5d1255df1065b9d1dd2f6cc5f45bf794181f263a83b976d12d70df27231255"
    sha256 cellar: :any, x86_64_linux:      "a824afb5435ebc4fa4133b95adef827bcda9307455def65e56e88f81daab635c"
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
