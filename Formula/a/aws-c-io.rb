class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https://github.com/awslabs/aws-c-io"
  url "https://github.com/awslabs/aws-c-io/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "8e2abf56e20f87383c44af6818235a12f54051b40c98870f44b2d5d05be08641"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4056b11f3763ed28884fc7c8148de5da7d64892d0554c772e37f3ad2747baaa3"
    sha256 cellar: :any,                 arm64_sonoma:  "fb1b9c52d33135a2b226240e0e409a3f4010263aff90cade3d0c059d85bd43c4"
    sha256 cellar: :any,                 arm64_ventura: "dac31bbf9726427172a71ce9ead89ec5f8d989a58c60d5ad5e5e0af5e79f4f7c"
    sha256 cellar: :any,                 sonoma:        "78a4afca3f62daf81221845e8b66d948fe81d1f18b5ce1e79d06aa5ebfd3ed97"
    sha256 cellar: :any,                 ventura:       "fd3101375ad6952873e07f48de73ce5e14972be69edbb64757d17b28260812c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "711d83d3b1ddb72fd29a7e3a3cf592f50b555ed2c43978b88b8dac2072cd90ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe068cff4bb9afb3fdb5595afb806918f91060b3c84b07b849dce173e76e8820"
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
