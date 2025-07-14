class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https://github.com/awslabs/aws-c-io"
  url "https://github.com/awslabs/aws-c-io/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "31232dd35995c9d5d535f3cf5ce7d561d680285a0e2a16318d4f0d4512b907c4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "47c904e291f4d40feea150cfabd25b2d5bc4d14f9db2e288e26873fed21d3ac5"
    sha256 cellar: :any,                 arm64_sonoma:  "a2165ccd07fb132134f71d603b63376f5d2fbfef0aa26f8091fdf9ea98a53dc5"
    sha256 cellar: :any,                 arm64_ventura: "b2b8ce485a1c551c621a620afd438b1036f3230277c2e6c9bf7c1de420ced8a9"
    sha256 cellar: :any,                 sonoma:        "2593caa0cc54083bf32060c4a9f1b5dc268801eb61a37a4e860a7928f994ac7a"
    sha256 cellar: :any,                 ventura:       "9f9821c99c776de066964422a7b76377170a005afa8d9d5d4c9dffba34bbe5fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "348f350acefacf472077c41fb22d7ecc1ef452deba2cbd1ed727a44278274303"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "396720c38788deac2510534d4e71d0e109783f266bf7050c60cba55e4e3179ca"
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
