class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https://github.com/awslabs/aws-c-io"
  url "https://github.com/awslabs/aws-c-io/archive/refs/tags/v0.26.3.tar.gz"
  sha256 "521fd0848fca661130bbb7278a414d7a38bdcb9bc8ffa89f6660d84e5838a303"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f96cf4e4319785524c71a88e1cb2f1d065bf5f4b0111c77887115777fbd8dc38"
    sha256 cellar: :any,                 arm64_sequoia: "3fa6c3a84abe7104e2161f822f6a653ba5b825c4d6f69ac829e61d2dd26257fd"
    sha256 cellar: :any,                 arm64_sonoma:  "4daec1224842c5e4cf4406c8ed9a04d331533e1107e0d192bde1f370035b7109"
    sha256 cellar: :any,                 sonoma:        "a2076fe1abd39e628ea7e796d1fea5595585e52ffa7e0884a5ebee3b419e599f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a16bcbe7b75b407602af6e23e84bcb9cbb96d6780d0f7c9642fcfbb8957bbc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c2b99161cba1c51c6562c0959ede8b4a9d2b468da23dc672aa1428c0ae5ce5a"
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
