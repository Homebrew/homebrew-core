class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https://github.com/awslabs/aws-c-io"
  url "https://github.com/awslabs/aws-c-io/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "356733a0d66f13a3f33fca709a693049615ec908ed3737b99d2f138055ebcbaa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "22c280480457b84d92ddbf544956ccf5026d1c45465a8c192ea8eb0c4f2263cd"
    sha256 cellar: :any,                 arm64_sonoma:  "d5cf901b045a61abf071501cc8f5d0caa8f4741f00f628dc3761ec77efbc0534"
    sha256 cellar: :any,                 arm64_ventura: "fd78138cef5bbf6f6ba9a958592c7659dfd82889bcc794038bf6ab5175b9a456"
    sha256 cellar: :any,                 sonoma:        "a399517cf41b75f7a3e6d658e36b8559310c51691b7663925d9970448191f092"
    sha256 cellar: :any,                 ventura:       "0dd749486084ad43622f060a726626c8978cf45c09b6a04b715adc7c96058c38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "327c94b8e58318294038871eda54393d75065081ac3d27b4d5842426140b6d50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12f0ea2e9cd3385ed9943521d90adfd3b33f451661602da22869951c51265a7d"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-cal"
  depends_on "aws-c-common"

  on_linux do
    depends_on "s2n"
  end

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
                   "-L#{Formula["aws-c-common"].opt_lib}", "-laws-c-common"
    system "./test"
  end
end
