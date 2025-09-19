class AwsCCompression < Formula
  desc "C99 implementation of huffman encoding/decoding"
  homepage "https://github.com/awslabs/aws-c-compression"
  url "https://github.com/awslabs/aws-c-compression/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "d89fca17a37de762dc34f332d2da402343078da8dbd2224c46a11a88adddf754"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c9e37702140dfa756eeb6c2fff4a319764847207c95d029b236212b02d91161c"
    sha256 cellar: :any,                 arm64_sequoia: "07ad5126a62967518823503ad65c6eceedb164aaa28e8f4b817d8fb8eb6d8f2c"
    sha256 cellar: :any,                 arm64_sonoma:  "e90f0d8370adc024e41c89f650c4fd37c62e396a05d369e1b8e834bca6cf63dc"
    sha256 cellar: :any,                 arm64_ventura: "8025bc877dd2221c32bb3527e34ee5d618156f40c972a13189857c63b0da2a56"
    sha256 cellar: :any,                 sonoma:        "cca91302bdbb311dbf40825511da49c15da10943ec8ee9bf4f0d2761a7885306"
    sha256 cellar: :any,                 ventura:       "9348145f22774820af3b513272e03e0d453b677d452671d42776fc0f735d7e4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29653a96519fab683d1b00e0df5611e28cee7a1c1b7a4f1e4fe711ca291ece1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a52c6fef0619145315545b21c86be299989bf437e5e8eac6bbc2ed817ac51dd"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-common"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <aws/compression/compression.h>
      #include <aws/common/allocator.h>
      #include <assert.h>
      #include <string.h>

      int main(void) {
        struct aws_allocator *allocator = aws_default_allocator();
        aws_compression_library_init(allocator);

        const char *err_name = aws_error_name(AWS_ERROR_COMPRESSION_UNKNOWN_SYMBOL);
        const char *expected = "AWS_ERROR_COMPRESSION_UNKNOWN_SYMBOL";
        assert(strlen(expected) == strlen(err_name));
        for (size_t i = 0; i < strlen(expected); ++i) {
          assert(expected[i] == err_name[i]);
        }

        aws_compression_library_clean_up();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-laws-c-compression",
                   "-L#{Formula["aws-c-common"].opt_lib}", "-laws-c-common"
    system "./test"
  end
end
