class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https://github.com/awslabs/aws-c-io"
  url "https://github.com/awslabs/aws-c-io/archive/refs/tags/v0.23.3.tar.gz"
  sha256 "cdcb31b694fc28ba96237ee33a742679daf2dcabfd41464f8a68fbd913907085"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "00f11c37fb3be3d7681c8a1f33d2cc13f660d4f4e3f1dce65c7fcac06d0fde6e"
    sha256 cellar: :any,                 arm64_sequoia: "0bdc40aaadb99d98c7fbddd5bb65536a30077b5cf739c846139875e5d9bddf51"
    sha256 cellar: :any,                 arm64_sonoma:  "2acaceb09ca5a936022e8807fc2c63dca68190dd96d5c7e2c2d4a697479fb097"
    sha256 cellar: :any,                 sonoma:        "03752a8c1cc43922a921fdf3e0e2499a129e4fb8015cd4074dad654a595ef996"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "271b594edd1bcc1a6ba8e1a4d8237c323fc54135ef5305522b49208d0ca1704a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98f1c1d0a00f9e3cee38810e8f7bcc498f84db17937438dd9364b45487ea9e39"
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
