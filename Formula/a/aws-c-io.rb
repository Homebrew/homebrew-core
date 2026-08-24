class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https://github.com/awslabs/aws-c-io"
  url "https://github.com/awslabs/aws-c-io/archive/refs/tags/v0.27.7.tar.gz"
  sha256 "cc84b1639c64af41ec7ea7397b020483f9bf73e3b07a72b16b4051b421079aa5"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ac47c3719e24bd3f3ef8e69fe49f05acf68b5288ea21bb9282f8c2cc7e4b13cc"
    sha256 cellar: :any, arm64_sequoia: "e7e9a65eb502dea8b301408a381805626e4da994b0b9de3e398eccd149d61ea0"
    sha256 cellar: :any, arm64_sonoma:  "01c168195a65098e9656680d5eb6812fbe0d678a2356bbc3a6e65fb98c5b8bf6"
    sha256 cellar: :any, sonoma:        "48af8ea6112217dff0292a7a5cac04bd4cf519189c6f2889a12b69736a85bb5a"
    sha256 cellar: :any, arm64_linux:   "976e84ef052c8c3f662924780696e7cea0623179cb3b1dddaf1afaeaff2dd540"
    sha256 cellar: :any, x86_64_linux:  "7b563c6a18474a5d1a6b8840e05e7334d7faf36a9edb1dd1297410fbdb0eb0cc"
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
