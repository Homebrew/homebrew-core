class AwsCS3 < Formula
  desc "C99 library implementation for communicating with the S3 service"
  homepage "https://github.com/awslabs/aws-c-s3"
  url "https://github.com/awslabs/aws-c-s3/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "c1c233317927091ee966bb297db2e6adbb596d6e5f981dbc724b0831b7e8f07d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7ee6d40ee24fec1f43f20ca25d4eed82aec15da13e11969372b1992ff9b09b3b"
    sha256 cellar: :any,                 arm64_sonoma:  "98193eaabe034bb863ba4b2f48e67aca58bc088e944480d981d7b43832c1bd75"
    sha256 cellar: :any,                 arm64_ventura: "0addb81ae415dd7c1e5bba2d2fe2afe0ce34b32fb8809446bf6317bed9ba8b12"
    sha256 cellar: :any,                 sonoma:        "8effc4869efdae0400bd8ae972cc70c7b04e1c4eb201233338f4dd8ea1ffc721"
    sha256 cellar: :any,                 ventura:       "a4c6971eebb172cd171bf23232a2814bd9bb58e8c09407156eda7e27a5c356d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e0baf3ac00b846a31e7dc5b8c0b9cc68255fbc573a96d5d52ec7dfc245b8235"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dea919d435d33383756bb416d1c7ef4f3aa0bcacebc146d2d3b7ebaece3b897"
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
