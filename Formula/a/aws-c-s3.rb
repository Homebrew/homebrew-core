class AwsCS3 < Formula
  desc "C99 library implementation for communicating with the S3 service"
  homepage "https://github.com/awslabs/aws-c-s3"
  url "https://github.com/awslabs/aws-c-s3/archive/refs/tags/v0.7.11.tar.gz"
  sha256 "6602c92c8b4602dee50636f4128a7842f7359314d030db35368120491b3582bc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "72f73b7f45700aaa043f8f9b31287702c6bdf2bfb0e173cbf1c1f0af2533abac"
    sha256 cellar: :any,                 arm64_sonoma:  "c1618156ef021e7d30f9e50eb312d2f90f0d039e68bcf386bf2c4d732c96aa8e"
    sha256 cellar: :any,                 arm64_ventura: "cca85069996891d362a456ca696adfe073d45dc9346fdb5adc925457c11ce42f"
    sha256 cellar: :any,                 sonoma:        "ad6bdb23743cab902252625fd766fab41670249c16cb493c6c8f8c85ac827ff6"
    sha256 cellar: :any,                 ventura:       "cbf82c495f78ec73efd218d29c9e131e53053bccea173eb3f55ae8316275a31e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0aa6137e875b96c394c916f966bdfb43a7965885a777d96d1a17fa1ac9cf00fb"
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
