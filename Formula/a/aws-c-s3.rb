class AwsCS3 < Formula
  desc "C99 library implementation for communicating with the S3 service"
  homepage "https://github.com/awslabs/aws-c-s3"
  url "https://github.com/awslabs/aws-c-s3/archive/refs/tags/v0.7.9.tar.gz"
  sha256 "1942161f9b9d656604a0efeb1387ad99d67d1f2d09154e0395c8bf5da2a39b7a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "96655bcbd3a7ed5e732dccf06fccd37750051beeffa137ebb83610cf1a6b4bc9"
    sha256 cellar: :any,                 arm64_sonoma:  "ea9a7a17312df5ab273fb6f88b41b1c1b056156416e1545605a5e3b333df9d7c"
    sha256 cellar: :any,                 arm64_ventura: "67157c9ba388bed2f4f525900509d50798833cbf245c42e1a110d6155d9bd678"
    sha256 cellar: :any,                 sonoma:        "1d722b40aa5b25acfc06d2d6eef022db3cbc3533f3f3040c61d11959f6dd551a"
    sha256 cellar: :any,                 ventura:       "4021c00757733cccdac9fb5f225b5d4d85ee5e952e302ac177fa458dd5d2c177"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "863ebbc660dcbc3323b7adff86b0277225cc75df288d68f038d74af01b77e53e"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-auth"
  depends_on "aws-c-cal"
  depends_on "aws-c-common"
  depends_on "aws-c-http"
  depends_on "aws-c-io"
  depends_on "aws-checksums"

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_MODULE_PATH=#{Formula["aws-c-common"].opt_lib}/cmake
    ]
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
