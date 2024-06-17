class Libnghttp3 < Formula
  desc "HTTP/3 library written in C"
  homepage "https://nghttp2.org/nghttp3/"
  url "https://github.com/ngtcp2/nghttp3.git",
      tag:      "v1.4.0",
      revision: "ac7ab2b1e82bd90a30e28da1c0476a90a62f34ec"
  license "MIT"
  head "https://github.com/ngtcp2/nghttp3.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4efd114bea4c541fb3599f9e38b8318e889b98173b0839256e27a4854e2be07f"
    sha256 cellar: :any,                 arm64_ventura:  "bed8e389269177a9aa3177b789952b2dd41f51ff3116b3e2e888f9a1a1417381"
    sha256 cellar: :any,                 arm64_monterey: "7ba53fe1c9daa6642ce6d43034d74a67ef1b79696d400c9ad02a3e4315390bc4"
    sha256 cellar: :any,                 sonoma:         "6e1bd4af33860b27600bcaf8eebee455cf1f05f245b0ce9fe0ddf5821eea506e"
    sha256 cellar: :any,                 ventura:        "6d5b6219a591d9c358007981dbd812da5831e94e80a29fe38c2ed184535523bf"
    sha256 cellar: :any,                 monterey:       "21e9e0abdebea44a225599d8ffdcc255734c9d9d01c0eaf94d9dd1b2f5763738"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1f2946b6c67e85f396491c611bde16b5f79e7eb243104bee5d7ae9f648f20b1"
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
