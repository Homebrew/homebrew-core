class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https://github.com/awslabs/aws-c-io"
  url "https://github.com/awslabs/aws-c-io/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "e89a1f784e7c97e4197031ffdcf30f67d66d7c14f8a391edf5764f17dae982ee"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e609e8b96dc257a38ee7bbe52216bd2c2e0983f7c75cb0fc07218d9a57ebb40f"
    sha256 cellar: :any, arm64_sequoia: "19f3a0d35b13ae26e07790f699148a08b6d5346eaa1c0dcded9bd793d8dbf813"
    sha256 cellar: :any, arm64_sonoma:  "8eab3782eab03b3be86af04734ee6f419e1953a8cc4c6ac8152b8c09105b9bfd"
    sha256 cellar: :any, sonoma:        "5e88ffa1c99a653fe3418b1a5e0994ed9f66fc939ee4cfe35bbf60d8f71f207a"
    sha256 cellar: :any, arm64_linux:   "31ea4e543100feededec8de4e3eb62e66354e120e8ea7e858d2b3d0f40b35550"
    sha256 cellar: :any, x86_64_linux:  "311e815f05c2e5b2db6b4503331dcd06813611aeb1eeda49c2f7a949a1451935"
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
                   "-L#{Formula["aws-c-common"].opt_lib}", "-laws-c-common"
    system "./test"
  end
end
