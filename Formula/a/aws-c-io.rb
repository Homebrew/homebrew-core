class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https://github.com/awslabs/aws-c-io"
  url "https://github.com/awslabs/aws-c-io/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "5da5bbfb97a2e52cea58ed1f76fb94a877df11763dcbd1373c14d699ed1efd18"
  license "Apache-2.0"
  compatibility_version 3

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e6b05f4a50dd72fca70c76fd4c743a26d6e9577304a674955444f4785e269f1b"
    sha256 cellar: :any, arm64_tahoe:       "9c424f187cf6b8dee49d85e57b74e1c9991fa8c6cd08f389ed03043542bbd764"
    sha256 cellar: :any, arm64_sequoia:     "b5ed0e9e1d6c7ba21686131d6164c0ab5dd71ac05cc1e17cf70c49b94c04f31e"
    sha256 cellar: :any, arm64_linux:       "970122eb4d55ef1dfbc0394de2a2b9705a1ad7e068725bd0f406da7ca3876c99"
    sha256 cellar: :any, x86_64_linux:      "d150f25eb06b82c3d70f034f778e69c36f3bc57edb747acf6126c117aef8c425"
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
