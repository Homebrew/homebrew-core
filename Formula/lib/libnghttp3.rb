class Libnghttp3 < Formula
  desc "HTTP/3 library written in C"
  homepage "https://nghttp2.org/nghttp3/"
  url "https://github.com/ngtcp2/nghttp3/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "838def499e368b24d8a4656ad9a1f38bb7ca8b2857a44c5de1c006420cc0bbee"
  license "MIT"
  head "https://github.com/ngtcp2/nghttp3.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "127334f5feedba39e77ce78cd55babfc5ce4ff2d775f60bb852f9c35179e67b5"
    sha256 cellar: :any,                 arm64_ventura:  "4df3b788e8e86b8f27a52ac01145a119cb17ea5610bf24357abf005b871e0112"
    sha256 cellar: :any,                 arm64_monterey: "fa489ff71d62930003c540c22375da5620c8246adcb66375afa003bf8b3826a9"
    sha256 cellar: :any,                 sonoma:         "9ade91c4ac6725e0e2023bb8bf9b257502891dadde3e5be6418700f3fa217eff"
    sha256 cellar: :any,                 ventura:        "58e9cdf3be7bad3a645ef57269faeb90c536ed90387e9fc49cf6e421ff858b27"
    sha256 cellar: :any,                 monterey:       "1a35c00d9e2125e057b3bea08dd87526f00807b72537d6927494dade7e727d36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35e0ae981233e48d9b4920049e68de7679e0be06fbdac6ce306b331c4aae48e3"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :test

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DENABLE_LIB_ONLY=1"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <nghttp3/nghttp3.h>

      int main(void) {
        nghttp3_qpack_decoder *decoder;
        if (nghttp3_qpack_decoder_new(&decoder, 4096, 0, nghttp3_mem_default()) != 0) {
          return 1;
        }
        nghttp3_qpack_decoder_del(decoder);
        return 0;
      }
    EOS

    flags = shell_output("pkg-config --cflags --libs libnghttp3").chomp.split
    system ENV.cc, "test.c", *flags, "-o", "test"
    system "./test"
  end
end
