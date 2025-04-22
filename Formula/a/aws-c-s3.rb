class AwsCS3 < Formula
  desc "C99 library implementation for communicating with the S3 service"
  homepage "https://github.com/awslabs/aws-c-s3"
  url "https://github.com/awslabs/aws-c-s3/archive/refs/tags/v0.7.15.tar.gz"
  sha256 "458b32811069e34186cfcef6c2d63a02b34657e70e880e1c0706976ce4b58389"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e7b3fba9dbfba28fc66bcac7aa65fbd7f7b0bf510638cb41e3f1ae6760168268"
    sha256 cellar: :any,                 arm64_sonoma:  "0dabdb078f36e2733a066ca957e952968e4ec399d8c0bc41ac30369ff658d3ab"
    sha256 cellar: :any,                 arm64_ventura: "3ce943e5a1732999378ab4c1d3fd549b72b228d707d69507fc20bd6ec5ad70bd"
    sha256 cellar: :any,                 sonoma:        "508d3dbd5dabd426c8fc9805134e62b674fdfd8c21bf450535a6bec254e9eae5"
    sha256 cellar: :any,                 ventura:       "436b3a860a89be2f63afb8a00634ed02e14c8d13950694a7645e2c4ed5e4e827"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e014304e6994b2f21576288d17a284f9ceedfd83c08442fce825ae603280fa59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5af2beb8263dcb2d3127852ff90725f20cef0cf6d8d8289cdbf7f14f38986f9a"
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
