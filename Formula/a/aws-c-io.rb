class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https://github.com/awslabs/aws-c-io"
  url "https://github.com/awslabs/aws-c-io/archive/refs/tags/v0.27.5.tar.gz"
  sha256 "aa132d5a728f18ab8e0a6ea96d3d2f7e66bc8d3fe029d9ed1b05c06aa0c5b900"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f9db5f1a4ac27ab0097dbafa50a8bea1b29432aaf8d9c51a3a37f36987a1cbf7"
    sha256 cellar: :any, arm64_sequoia: "17096914b8409ef5741955744d254e582b845b0cd36e78debdb6cc1238994139"
    sha256 cellar: :any, arm64_sonoma:  "8af1b0db8da51645e389733eee6c996bcc31e3c59a93807cd65d7bf7cb994020"
    sha256 cellar: :any, sonoma:        "687b050e540f8614e4cd8a736beaa65c98e3c170289424876ab4299e20f86dc1"
    sha256 cellar: :any, arm64_linux:   "9fbac3b72d9bf1d0aa27b6953fb84908c779cc09c4d3be4804db73b3ab92ae80"
    sha256 cellar: :any, x86_64_linux:  "c4ed8fca9b0dd0713c25cb6305c2b6cb55645852bfe4ba03464c96d1a5700b86"
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
