class AwsCS3 < Formula
  desc "C99 library implementation for communicating with the S3 service"
  homepage "https://github.com/awslabs/aws-c-s3"
  url "https://github.com/awslabs/aws-c-s3/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "0b2f2a6d3b17c6d0684b80cc6581dd1b99ced39bfbb633fc9a1b16bf3f8eaa66"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7ab52539f2e0a93ba605bbb9ebbed92f397858851572c6aca11341b62a1a97f0"
    sha256 cellar: :any,                 arm64_sonoma:  "1e2e2123dedf8280532008f81173bdc3e5150af01888dae7e7722d378ba98ed9"
    sha256 cellar: :any,                 arm64_ventura: "ff784e64ca0be21c024255dda71ef88f264d8e397bf7a2313f77dfc2478c3d91"
    sha256 cellar: :any,                 sonoma:        "4a9c86bd232677578a83f48ac0b28d866ad607af04ae3237488a578f2d2a1206"
    sha256 cellar: :any,                 ventura:       "a787c2c5a9088ea9c4493d62da46beb053b5e0bfcfee805be50631f886ae92e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "780881a5d60adc98c945306f6f33e3c483f9d20d957abb20b19f9b4970f9cd8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f10e6b0261eaf8dd5622d3a58c80bd0822aeac95fdd5dd4abb8da87aeee05b6"
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
