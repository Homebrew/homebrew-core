class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https://github.com/awslabs/aws-c-io"
  url "https://github.com/awslabs/aws-c-io/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "f2fea0c066924f7fe3c2b1c7b2fa9be640f5b16a6514854226330e63a1faacd0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bc4ee0648dc6f4d6dfb597f755fa8ff9ef32832af455795a4562563a40d88c6c"
    sha256 cellar: :any,                 arm64_sonoma:  "eb634dedd30d0118b16701b16444683176b6c75d1b007191388291e164c78fc1"
    sha256 cellar: :any,                 arm64_ventura: "1de3124076ae116d4b070627d1cdf05694416fd49263938a5ef2474da24631f2"
    sha256 cellar: :any,                 sonoma:        "462986e5bb6a3f55f56fa545d11b4c0100d482e551353448353ec8dd9a442391"
    sha256 cellar: :any,                 ventura:       "ada350329ded28471a415175ab2a1d697ac2105c25183e2f12dbda6b850c5824"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd4022dd1a7fe007e90362887e241ef8d22d60ee0be0c476574a3b5fcadab473"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d78f49b15ac666208be888ddf3ddf220d95f3d02172a56f22039be3cc99676d"
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
