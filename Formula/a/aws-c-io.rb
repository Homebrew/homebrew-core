class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https://github.com/awslabs/aws-c-io"
  url "https://github.com/awslabs/aws-c-io/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "a437ec3b5929582d79f43904e4939626db19d6fd30c44cb16841bc70c7d6548b"
  license "Apache-2.0"
  compatibility_version 3

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a7192b7f1838716ca24b671213d7cb86a98051066a47d5fc0dfd5a635add6cea"
    sha256 cellar: :any, arm64_tahoe:       "b036392ace4c791d5c3166f7517f0238540175791e937587c66d631325135b0d"
    sha256 cellar: :any, arm64_sequoia:     "5124450c7aa72d93315776bc2cb38ff67de0d15dacf72bfda3be41af62d3b96e"
    sha256 cellar: :any, arm64_linux:       "be8e1fcbda881a60d58e4c924890794fc703c6f687f2624b68647e1cc5724aa0"
    sha256 cellar: :any, x86_64_linux:      "4df75a873dc8ad4cf4c634972931ce3b4926e65531375e51e7632e3949c74679"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-cal"
  depends_on "aws-c-common"
  depends_on "s2n"

  deny_network_access!

  def install
    args = ["-DBUILD_SHARED_LIBS=ON"]
    # Avoid linkage to OpenSSL
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
