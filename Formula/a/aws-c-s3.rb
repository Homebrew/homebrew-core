class AwsCS3 < Formula
  desc "C99 library implementation for communicating with the S3 service"
  homepage "https://github.com/awslabs/aws-c-s3"
  url "https://github.com/awslabs/aws-c-s3/archive/refs/tags/v0.7.12.tar.gz"
  sha256 "096ac66bc830c8a29cb12652db095e03a2ed5b15645baa4d7c78de419a0d6a54"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "799f60ad9662ce3146c742bdd23320a2c94cc85e648b4176f2faac0cd26c51ea"
    sha256 cellar: :any,                 arm64_sonoma:  "0ef42217cf7f0aef34bdd5609577092ddbe6c90d11634b79e863b58a60119b5a"
    sha256 cellar: :any,                 arm64_ventura: "a89e68bee2d886d87acedb08feba1937a6c2b16d48dca4ab086caabd0369973d"
    sha256 cellar: :any,                 sonoma:        "79d76f327013c5622ffa011f9a3896fe90dfc11e625e9517e1db4556fe0607c0"
    sha256 cellar: :any,                 ventura:       "67821f7e86bc18438b0824c24d239b6f883d0fe6b912787bf85764d2013f44dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28d19f90e169bb63d65cd34da8baaa7307320fe7483ab7af7b2c322f9b92957c"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-auth"
  depends_on "aws-c-cal"
  depends_on "aws-c-common"
  depends_on "aws-c-http"
  depends_on "aws-c-io"
  depends_on "aws-checksums"

  def install
    args = ["-DBUILD_SHARED_LIBS=ON"]
    # Avoid linkage to `aws-c-compression` and `aws-c-sdkutils`
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <aws/common/allocator.h>
      #include <aws/common/error.h>
      #include <aws/s3/s3.h>
      #include <aws/s3/s3_client.h>
      #include <assert.h>
      #include <string.h>

      int main(void) {
        struct aws_allocator *allocator = aws_default_allocator();
        aws_s3_library_init(allocator);

        assert(0 == strcmp("HeadObject", aws_s3_request_type_operation_name(AWS_S3_REQUEST_TYPE_HEAD_OBJECT)));

        for (enum aws_s3_request_type type = AWS_S3_REQUEST_TYPE_UNKNOWN + 1; type < AWS_S3_REQUEST_TYPE_MAX; ++type) {
          const char *operation_name = aws_s3_request_type_operation_name(type);
          assert(NULL != operation_name);
          assert(strlen(operation_name) > 1);
        }

        assert(NULL != aws_s3_request_type_operation_name(AWS_S3_REQUEST_TYPE_UNKNOWN));
        assert(0 == strcmp("", aws_s3_request_type_operation_name(AWS_S3_REQUEST_TYPE_UNKNOWN)));
        assert(0 == strcmp("", aws_s3_request_type_operation_name(AWS_S3_REQUEST_TYPE_MAX)));
        assert(0 == strcmp("", aws_s3_request_type_operation_name(-1)));

        aws_s3_library_clean_up();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-laws-c-s3",
                   "-L#{Formula["aws-c-common"].opt_lib}", "-laws-c-common"
    system "./test"
  end
end
