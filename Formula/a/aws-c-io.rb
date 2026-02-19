class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https://github.com/awslabs/aws-c-io"
  url "https://github.com/awslabs/aws-c-io/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "5481178b99f074314b23b39b35786715fb0c1bf9773023ff83efe0d62d6e0ce2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cc12f673bff8e14b9028ba9dd5d63f3569e18504b73b011bdcd5c1360fd9e632"
    sha256 cellar: :any,                 arm64_sequoia: "9d517b93eb5aa9928001e879b73cda880bb098e55dc1dc306e44544d833b2128"
    sha256 cellar: :any,                 arm64_sonoma:  "729b66fa364fba7de210ab575b6f6b93987aeeb17f361b08de350bc2f6d52696"
    sha256 cellar: :any,                 sonoma:        "798efa5bf8d2e5665091cc786d9be22517645b1c7e3962e5d2a84d2010fd012a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e379afae8bbe78246c0731c24fa683d2d72d5ee29c1e44c8fa8b6be087c0b77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34e2da3546cdf4ee4a322be2077de0a1606765109e8c765c2b1ef1d7495024c8"
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
