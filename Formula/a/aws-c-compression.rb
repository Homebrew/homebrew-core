class AwsCCompression < Formula
  desc "C99 implementation of huffman encoding/decoding"
  homepage "https://github.com/awslabs/aws-c-compression"
  url "https://github.com/awslabs/aws-c-compression/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "d8e934da2086bfec41f97a0cff749d926f66ccb90f2052f1d70841916c1bf4d7"
  license "Apache-2.0"
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1184715015c20e58d899f72a3d0f14b4bd82b21bbf730372ab9b293d21c24ac9"
    sha256 cellar: :any, arm64_tahoe:       "a2c53e81a0a8f5295ec41f79a5db591c1eea53b8eeac19b6c8649cdc2c676b46"
    sha256 cellar: :any, arm64_sequoia:     "688a0f79a1afe8229ccd16d7e08c4d6305769b97a95553ddfa0d4c16822d529b"
    sha256 cellar: :any, arm64_sonoma:      "cf70d1c2341589cb2a83ea8921e25daa26576bca77f4deafac44b8cc72cb7a0c"
    sha256 cellar: :any, arm64_linux:       "4833565f88f12bd9c6bf691625276b2f29490d698a498338a56705986428f103"
    sha256 cellar: :any, x86_64_linux:      "ee4a9b37eb62286239c49703c84c71362c6e792460e7d042544191d27b8566b8"
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
                   "-L#{formula_opt_lib("aws-c-common")}", "-laws-c-common"
    system "./test"
  end
end
