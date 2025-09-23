class AwsCS3 < Formula
  desc "C99 library implementation for communicating with the S3 service"
  homepage "https://github.com/awslabs/aws-c-s3"
  url "https://github.com/awslabs/aws-c-s3/archive/refs/tags/v0.8.7.tar.gz"
  sha256 "bbe1159f089ac4e5ddcdf5ef96941489240a3f780c5e140f3c8462df45e787ac"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a6377b91ce421d996ee74aaa8457a75f0d0f7beb42c6ed5a266e5d81d93b6d13"
    sha256 cellar: :any,                 arm64_sequoia: "338bb9109a67ca01fe65189f37f9f1b88ed083067935742b216804687c918b9e"
    sha256 cellar: :any,                 arm64_sonoma:  "430733199f4e280bf5f969526109edf5e54c081d737638614a622a9aced7b8b1"
    sha256 cellar: :any,                 arm64_ventura: "700712143ffacbb5f5336d641d9e0cc5c1acc05f6d176ecae187ba51f6c9892d"
    sha256 cellar: :any,                 sonoma:        "948380a18bce4efb5e611d9429de12fe0950a07ce56b4c56b7c8177dfeefd92e"
    sha256 cellar: :any,                 ventura:       "34fa0792730fdc639c992e6a775e1bfe0d14cefbea96160c046be4eacf1f95bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ac7ee9c25996a21847b7bc624c2af123ff424491572ac08cb39cf1aa50a606d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99bde15a8bb5a39d5c1d9879e1ec3ef3e475d5c5694ed01d033cc35335a603bc"
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
