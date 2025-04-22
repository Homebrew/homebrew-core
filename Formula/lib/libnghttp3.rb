class Libnghttp3 < Formula
  desc "HTTP/3 library written in C"
  homepage "https://nghttp2.org/nghttp3/"
  url "https://github.com/ngtcp2/nghttp3.git",
      tag:      "v1.9.0",
      revision: "9ee0c9248f97c502cce01e6c8edcccd3723c61e6"
  license "MIT"
  head "https://github.com/ngtcp2/nghttp3.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "07df76d04a3b7879cc6669a4da943f26190d90f997a032d299bc5e63dab18f65"
    sha256 cellar: :any,                 arm64_sonoma:  "ad6f7c387f7f244a2032d6a3dfb61029b9faeeb4c6d90f892ca98e4ccfaa098f"
    sha256 cellar: :any,                 arm64_ventura: "616f5c0613555d9a5f04744c6c73c43cecaeb98679542c5d65d9d1eaaa9edc94"
    sha256 cellar: :any,                 sonoma:        "07812e22007268bdde352348ba8e53dd309f76a7f48543866ea3c2eada1afb17"
    sha256 cellar: :any,                 ventura:       "42ea9a7b21c4860e5eceb6012a4d3d84f4be6d1df76c4189ea6ac73426e5da0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8de8c24f2bc68715f84d65f7e57a3227422b21e40d36167efee2d602706fbc0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca820a826f6bfd1895dc78a7b371f13928929000415316360253747e349a77af"
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
