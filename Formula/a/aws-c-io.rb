class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https://github.com/awslabs/aws-c-io"
  url "https://github.com/awslabs/aws-c-io/archive/refs/tags/v0.27.4.tar.gz"
  sha256 "0f2ce32de3685ca5ba3a8395d461c783253c1718cf70d31378eb6be890db1e3e"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f248f4ba68758cc20219c3b89596dac9a76d0341625751bf19bb959aa764ceaa"
    sha256 cellar: :any, arm64_sequoia: "3ee9ec74d8a5c6c920fcb1b8a69496b58e4d73befcd1696d52afdaac38355015"
    sha256 cellar: :any, arm64_sonoma:  "33f82874c32b3c512dfba61f777c598678588e375d016a568724a33b41052aeb"
    sha256 cellar: :any, sonoma:        "edf328eb70ce8e182063bd6e01fa37c840984c3a10b9252d24fb23946ec5cfcd"
    sha256 cellar: :any, arm64_linux:   "0880136661d0a16fcb394de4d938f6592d79710ac94b1bdc4932384103caffca"
    sha256 cellar: :any, x86_64_linux:  "eedd763c3633e6cb7acb6147360ff87e504c6def6d3de7cbfee1ebfc115352e0"
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
