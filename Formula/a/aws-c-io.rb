class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https://github.com/awslabs/aws-c-io"
  url "https://github.com/awslabs/aws-c-io/archive/refs/tags/v0.27.2.tar.gz"
  sha256 "42caef5ef624ca8f5046d4e9f21c8dcaf1c4d7d0b2d46d965357b13079f2d2d3"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "047ca86439e4aedaa13ec16c2ef4fcc148052c818ed03ace8dffe5832cfefe3e"
    sha256 cellar: :any, arm64_sequoia: "a15620e07e6186e8539f1d5cd90d27ee5b5aca906f67f4f35ee401690e25a0fe"
    sha256 cellar: :any, arm64_sonoma:  "9fbdc7f22913bb02d3ef7b794d530189a47b66235d382e66cef59f55d6c2111d"
    sha256 cellar: :any, sonoma:        "5d662d42b6c340b21f666687ea210986b2a9182448000e12a9a04a8869b314dc"
    sha256 cellar: :any, arm64_linux:   "ce802693acb4b0ba791ab8ddefc6af0bb63e1d9e26460fe2c3ef25faf9fa7c33"
    sha256 cellar: :any, x86_64_linux:  "52fb201477fd730551f827ae3de9778f69cf333006605bfb0dc29c7ec99b7bb9"
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
