class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https://github.com/awslabs/aws-c-io"
  url "https://github.com/awslabs/aws-c-io/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "27591a4d67b7401dc0b87f8fec91b1c93764decb32229086113c80d4d6d6d3c0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "32cc5edaebb4a99ef17f70f8687a6ffaf2af9101e3a926b91214f26931a90873"
    sha256 cellar: :any,                 arm64_sequoia: "b42702a516121286d8107ca1a1d188c064f93b656da73fd0aaf6b19a910eab64"
    sha256 cellar: :any,                 arm64_sonoma:  "9ddd279c6850b9efa54fb16e6c5f343ddf930abe34966da962d7157821b5e085"
    sha256 cellar: :any,                 sonoma:        "9538c35c9d1b3306287ae92bd32676875e3f7d69d2a9b379ab948af5f3ca0524"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12796c958a2f6c04dd7584b4b8ceb171d8e5a6e7ac8542e2c082ca616a185941"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5e47c25c247da7a427e460333e53515f746a052e45b776abdb4e04591b40f48"
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
