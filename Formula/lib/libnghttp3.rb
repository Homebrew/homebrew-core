class Libnghttp3 < Formula
  desc "HTTP/3 library written in C"
  homepage "https://nghttp2.org/nghttp3/"
  url "https://github.com/ngtcp2/nghttp3.git",
      tag:      "v1.3.0",
      revision: "e4f96f9572e4fc27324b4a009d877a4a2bbacc4e"
  license "MIT"
  head "https://github.com/ngtcp2/nghttp3.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "41a39c62a827354fd9fe72647dd2a39eec2616b8e109be1796fbfb7ff19bf3c4"
    sha256 cellar: :any,                 arm64_ventura:  "82ac76bbfc3777a3c14e5ad712509cc93496beff4ad251c29aa8c635a3544076"
    sha256 cellar: :any,                 arm64_monterey: "4182192ed2957c37084ebaf4bf894d6a197f195c7c19ec27e3085131067ce04d"
    sha256 cellar: :any,                 sonoma:         "4953287009f91877b421e38c8b5c11ed03def018ef72bc0464a62f2915fe22b5"
    sha256 cellar: :any,                 ventura:        "2c1d27d5a1b7ea447ad7a87b322f57f909e5ec8b44d06a74d902eefb0116cfe6"
    sha256 cellar: :any,                 monterey:       "8561d2cccbabdfbc2bd05c8b28e18c277e5810258b5d7f7bf2d47376f648d63c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "772319c74c07a0f228dbea3880be57850f2a78480439a4e78cbee1d63073c8d4"
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
