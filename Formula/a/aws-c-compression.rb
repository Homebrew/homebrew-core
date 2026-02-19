class AwsCCompression < Formula
  desc "C99 implementation of huffman encoding/decoding"
  homepage "https://github.com/awslabs/aws-c-compression"
  url "https://github.com/awslabs/aws-c-compression/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "f93f5a5d8b3fee3a6d97b14ba279efacd4d4016ef9cc7dc4be7d43519ecfbe93"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2f21b6ad21619121cdafdc6cab4fe62b71cf845b7a281211a5099dd02b49f12a"
    sha256 cellar: :any,                 arm64_sequoia: "a5331bcd673f255c1aa6a40444f650bf8bd14ff8426fd70059ab3897ab445bbe"
    sha256 cellar: :any,                 arm64_sonoma:  "3d3710eda9b726d9129d7299699dc76c13078a69d35a7a458e892976ac74289c"
    sha256 cellar: :any,                 sonoma:        "90624e8c8471e6d1922b9bfe4e215a42e1b938fc2d13f14ad65a04db0d2c1baf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30c32bddc0dc1bda08c68edf91cd62444b265e09ce00d0fc772efeea627a93d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12443c30024526e9902b8bc57bc22dd8bd950d7e7b5dab799cc7fae31a895f49"
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
