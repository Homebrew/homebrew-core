class Libnghttp3 < Formula
  desc "HTTP/3 library written in C"
  homepage "https://nghttp2.org/nghttp3/"
  url "https://github.com/ngtcp2/nghttp3.git",
      tag:      "v1.2.0",
      revision: "2e3cce607fe3e5e248bfd363f616c4fa520a5b95"
  license "MIT"
  head "https://github.com/ngtcp2/nghttp3.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "276a8ec1843955e4cdf8626f374ceae2ab402b9e650b5fc6943d9878c5187c14"
    sha256 cellar: :any,                 arm64_ventura:  "f013c978f75bbded75025864eb5767f9a55bb7e6d6560c9378fc47e4115a86ff"
    sha256 cellar: :any,                 arm64_monterey: "97ebb377467ff9d3f3ef9d9682024d75b9b1d6c4b3c361937dfd2f92053e4788"
    sha256 cellar: :any,                 sonoma:         "f8d10367cde6637b6ab8610362c1beeea64d463042c0a1cccb0b4f5ad6654f89"
    sha256 cellar: :any,                 ventura:        "3fe1aa1343ae5fae9956050214a768b07a77a91b50922c0c0b3d8797ca963f7a"
    sha256 cellar: :any,                 monterey:       "cab18245d0b2e8f5a1d54665397d1d81df18401ebdf91428b693c853a9d28789"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b76822612442a9320b522660ede482be86b8da988456a3be80ccdc0ed8a94fb"
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
