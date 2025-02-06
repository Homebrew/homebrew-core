class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https://github.com/awslabs/aws-c-io"
  url "https://github.com/awslabs/aws-c-io/archive/refs/tags/v0.15.4.tar.gz"
  sha256 "e5202033b09df61ffb2a57284a04735ac013296decc107de1c4abd1ce7d5cfda"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5bc7c81d9c29a20ce26ce6fac7b04f6d325e6e29a7fe3d34cff17a090a983cc8"
    sha256 cellar: :any,                 arm64_sonoma:  "9c2d9789fbcfaec6f0ecbbbef374fa3de81f76ece9803812ed6d1c3cb0716063"
    sha256 cellar: :any,                 arm64_ventura: "a1087c828ba6191ebd020adbddf0ac1186c3a265da8d49d6a5da13a9d8d473c7"
    sha256 cellar: :any,                 sonoma:        "12dba0c11d0f37ca2581699395657e4fb24bacb84222853e634c2e8512394ad0"
    sha256 cellar: :any,                 ventura:       "40069e67bd3f47da854aa2fecc8d5ced5a44ebea79467751544f994c3bdc3aa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe14feb814aceeb8bbfc433e3e1f55f3fb3283688e5538f9755c2a23f2e70e88"
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
