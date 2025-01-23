class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https://github.com/awslabs/aws-c-io"
  url "https://github.com/awslabs/aws-c-io/archive/refs/tags/v0.15.3.tar.gz"
  sha256 "d8cb4d7d3ec4fb27cbce158d6823a1f2f5d868e116f1d6703db2ab8159343c3f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "469de82757523b94efc41e8ace0a482d750ecd0aceb2df9090a2ea23d4b02484"
    sha256 cellar: :any,                 arm64_sonoma:  "81df61ba419531bf106653fbd735f88f281493a98b5f3f699567f83caeafd2f8"
    sha256 cellar: :any,                 arm64_ventura: "ecd9199b467d67b45e631d7530645c652e61d3875f3cfb267e479ae44dd35161"
    sha256 cellar: :any,                 sonoma:        "7a7f6a942570d98acd89d560aab36b979bde43c96363c3eeef167a21871868f0"
    sha256 cellar: :any,                 ventura:       "18c41ebc9f73e8a607621b93c219d0f22204d75910aba9cc25ceddbb6e46022d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cc6f16cf5dcc1015926d002729cf31883de6f89b127eb9a9d23ac7c6d58c358"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-cal"
  depends_on "aws-c-common"

  on_linux do
    depends_on "s2n"
  end

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_MODULE_PATH=#{Formula["aws-c-common"].opt_lib}/cmake
    ]

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
                   "-L#{Formula["aws-c-common"].opt_lib}", "-laws-c-common"
    system "./test"
  end
end
