class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https://github.com/awslabs/aws-c-io"
  url "https://github.com/awslabs/aws-c-io/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "07b0ac7271e482e1f5f1e84fcf33ec23fb8a2c12e7a7f331455a5f1d38b9fbfd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "62ad6b49561a51e6b3f9bfce8ae10796a58371dcd3722fb58cd20714ddf8f131"
    sha256 cellar: :any,                 arm64_sequoia: "c9b15a2e42e675a6d1055c2a9c213fe7ad92c1e7e5e90492f7b8d92d2cf54b30"
    sha256 cellar: :any,                 arm64_sonoma:  "ea5974b1c0fb0e0446192ca4b169f0c31a1a0c4b90cbbe77d58f8132754bd126"
    sha256 cellar: :any,                 arm64_ventura: "3e9d6eba02f43a0162bd51b190a907b6fabb834a666729022b43c7ade7c1961a"
    sha256 cellar: :any,                 sonoma:        "7b11e0a38e19fd261b679203b7c30579d67779c3149a3646d84343ac34236f31"
    sha256 cellar: :any,                 ventura:       "71159ae671a4203a725dd4e9a9f698e6cbbcd2950e0f3185f52ba287de0e3cb5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e23ec8cc2043c1deecd9a4e79b6b33bd1e9a9625a872fa76001a918d98c5105"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ab27afa87addc6c16d7604dc96325be3aa587120277092fbc833d7d984c9b8c"
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
