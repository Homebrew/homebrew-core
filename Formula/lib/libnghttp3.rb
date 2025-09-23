class Libnghttp3 < Formula
  desc "HTTP/3 library written in C"
  homepage "https://nghttp2.org/nghttp3/"
  url "https://github.com/ngtcp2/nghttp3/releases/download/v1.11.0/nghttp3-1.11.0.tar.xz"
  mirror "http://fresh-center.net/linux/www/nghttp3-1.11.0.tar.xz"
  sha256 "27d084518f06d78279b050cc9cdff2418f80fb753da019427ce853cec920f33f"
  license "MIT"
  head "https://github.com/ngtcp2/nghttp3.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a192e425b1ed18fdef7fe60a301433fd8111c595ab427fa8d42e2bd1e50f94a6"
    sha256 cellar: :any,                 arm64_sequoia: "1c9d28dd6fde53d9fa821b5193f3544efb334ff6a22c9153a3ad962f0263c7dc"
    sha256 cellar: :any,                 arm64_sonoma:  "0477cbc1c7fa2703ecd3fa23f1cb3186e8ea7a7d8cbeef80e0613e092f447bc0"
    sha256 cellar: :any,                 arm64_ventura: "8fdbe6c9891d73701f0d9de72fe5de56f84073268f076767645c058184ea8936"
    sha256 cellar: :any,                 sonoma:        "0a683e0b2ef8a5a3096e1749af7e0ea4adad5c30d318d95cdc8baa5fb073fa5c"
    sha256 cellar: :any,                 ventura:       "206c971511cc68e40baecefd674b4ea960245189167643d569dd92e500829d0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42b60662e3756b35eaa765911435236bd50c3a320e8f461af7883c5e9ce35d79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bc24ee540174ccaae7458e82f5b7d61affbb4b2cb0a927efcbe8d206e3ca8ec"
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
