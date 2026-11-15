class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https://github.com/awslabs/aws-c-io"
  url "https://github.com/awslabs/aws-c-io/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "5da5bbfb97a2e52cea58ed1f76fb94a877df11763dcbd1373c14d699ed1efd18"
  license "Apache-2.0"
  compatibility_version 3

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "59075a59e321d1de870b509f4412c88e57998cc1ed686ea0210a847f2a1db16c"
    sha256 cellar: :any, arm64_tahoe:       "358a3c0c91b18cff6206eccc98cc1540be5e0f1bf5125095290f4f37a6cbe71c"
    sha256 cellar: :any, arm64_sequoia:     "fa73d2047a4ad15c8898e5fbbcc1f0f25c858c79e14d18a11e9913a810979170"
    sha256 cellar: :any, arm64_linux:       "1ddae2d9e38ff8308cd60fe214b78448e5d1df4c6236c3c833d0b5ac75d4fb3c"
    sha256 cellar: :any, x86_64_linux:      "ffe793934a176d04b5da145ac8bee7d20e0fc1a5ecc459238ab7c8e224e642ae"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-cal"
  depends_on "aws-c-common"
  depends_on "s2n"

  deny_network_access!

  def install
    args = ["-DBUILD_SHARED_LIBS=ON"]
    # Avoid linkage to OpenSSL
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

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
                   "-L#{formula_opt_lib("aws-c-common")}", "-laws-c-common"
    system "./test"
  end
end
