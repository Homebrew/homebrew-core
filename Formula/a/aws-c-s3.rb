class AwsCS3 < Formula
  desc "C99 library implementation for communicating with the S3 service"
  homepage "https://github.com/awslabs/aws-c-s3"
  url "https://github.com/awslabs/aws-c-s3/archive/refs/tags/v0.13.7.tar.gz"
  sha256 "f15b0696d915a3189b4eee6b750fe8d1fbc84b33f94518071725a0f3a8ffc63d"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ca01a7296cab7a1fe25a6ebd393b24deeb9a3518511738e744869f396b9e62f0"
    sha256 cellar: :any, arm64_sequoia: "a855fc784cd4957b6ab5eca253f1ca7eb73fbcfe76703adabbeece61e324ee09"
    sha256 cellar: :any, arm64_sonoma:  "ad122a5702bc57c15b72b17fa824e0c2aadcc6b345a49d9190c5e33a77559645"
    sha256 cellar: :any, sonoma:        "d3be58e329a8c2e3c55bf08c61b33105e76449e3f93fcd7b96800a6213c8dc87"
    sha256 cellar: :any, arm64_linux:   "979dcabf1e2d50f4fddd81e903dd318d4a12a5bd2d250dbf54b13e091c5dcc17"
    sha256 cellar: :any, x86_64_linux:  "1beadbf86c2cae078f53a42c8841dbfb889e9f225e34bfc4d86dd691c3726c7d"
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
                   "-L#{formula_opt_lib("aws-c-common")}", "-laws-c-common"
    system "./test"
  end
end
