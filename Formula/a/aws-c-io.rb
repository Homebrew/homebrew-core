class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https://github.com/awslabs/aws-c-io"
  url "https://github.com/awslabs/aws-c-io/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "4ae2ccb8fe9992c7e8aac7eb9f551b49d12548bdfe2cbe9a1ab3415100aae1d0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e6b4cba9f75e409534746e0898ea4a080630274b56436c84a625f256d9fe9b0d"
    sha256 cellar: :any,                 arm64_sequoia: "bab217fce7acd9aa9966a2c1f81b65b244ab398a8c7114874f9267065a68347a"
    sha256 cellar: :any,                 arm64_sonoma:  "78015fbef6a052f7d9b22005edef0618dd973c91a65b6bd6fe3a960b38096ec0"
    sha256 cellar: :any,                 sonoma:        "06571f20fe56639e87461b418aca788ecd496579a29b7b7611d20804e3e558c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5a49e1b8e68bbea40767df5f15ab137b17adb2dfa973d92d22129c61f10a635"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9cba71e1e26393c8d28b8a93d45e5e62c1c514f752c9ca54c5a52b330db6da4"
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
