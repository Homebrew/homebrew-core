class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https://github.com/awslabs/aws-c-io"
  url "https://github.com/awslabs/aws-c-io/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "5fecb19c2c0a165687cdd94723943a02ab23a0270deade5661fd935a3cd55e78"
  license "Apache-2.0"
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2ec493e1ab13a40ced07a5b7203b2a8cd2ef607547bd9a0543f7ca56a0aa18e4"
    sha256 cellar: :any, arm64_tahoe:       "65af61010890938814768b618a543ab222ab760ad19a08e8c7e6e075d03d16dd"
    sha256 cellar: :any, arm64_sequoia:     "85e9dc2ac23c5d280e71e3f71b7107385282f3fb2cc2206a1bb5d8e6a7e2852d"
    sha256 cellar: :any, arm64_sonoma:      "290d7a03edbc9c44a563458520150777ceb1474514bb53f54a2f8aa560f126ac"
    sha256 cellar: :any, arm64_linux:       "dda27f924d1af2035f485ac5324803482d396ac4de993e2b4151f45a47632aa9"
    sha256 cellar: :any, x86_64_linux:      "4c0b9176cfa29cde228f14084758627c0c584c934ac3968313ed39416f5fb587"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-cal"
  depends_on "aws-c-common"
  depends_on "openssl@3"
  depends_on "s2n"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <aws/io/io.h>
      #include <aws/io/retry_strategy.h>
      #include <aws/common/allocator.h>
      #include <aws/common/error.h>
      #include <assert.h>

      int main(void) {
        struct aws_allocator *allocator = aws_default_allocator();
        aws_io_library_init(allocator);

        struct aws_retry_strategy *retry_strategy = aws_retry_strategy_new_no_retry(allocator, NULL);
        assert(NULL != retry_strategy);

        int rv = aws_retry_strategy_acquire_retry_token(retry_strategy, NULL, NULL, NULL, 0);
        assert(rv == AWS_OP_ERR);
        assert(aws_last_error() == AWS_IO_RETRY_PERMISSION_DENIED);

        aws_retry_strategy_release(retry_strategy);
        aws_io_library_clean_up();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-laws-c-io",
                   "-L#{formula_opt_lib("aws-c-common")}", "-laws-c-common"
    system "./test"
  end
end
