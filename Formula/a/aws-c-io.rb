class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https://github.com/awslabs/aws-c-io"
  url "https://github.com/awslabs/aws-c-io/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "65d275bbde1a1d287cdcde62164dc015b9613a5525fe688e972111d8a3b568fb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "928e89977a132dd0e1213d6a5095fc5bd47fecd2a03211f8e83e41e7e621c154"
    sha256 cellar: :any,                 arm64_sonoma:  "02560f632536c421a9391c1ec4493f3ba3c590298fe28f3304befd1051f8261a"
    sha256 cellar: :any,                 arm64_ventura: "cbe324b726a4d1d4b44121356c401bd2be22d46b2103a667bb71292d00b3e5a5"
    sha256 cellar: :any,                 sonoma:        "2376115e3aaa69327527232078b7e00d033c510877c2899466f570ca1bb545bc"
    sha256 cellar: :any,                 ventura:       "65820ef104dcd151c46aa843355090a3f6722b10a92c9ce736a26f7bd401dc0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9186d3096edf027ad020bc0c7890860f2c383895326c915b249454c2d99c4f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4165c5c4abb2ee63603fd68f36c346a63244fef664229a75d0cd030168c0b3e"
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
