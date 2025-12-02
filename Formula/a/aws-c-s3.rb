class AwsCS3 < Formula
  desc "C99 library implementation for communicating with the S3 service"
  homepage "https://github.com/awslabs/aws-c-s3"
  url "https://github.com/awslabs/aws-c-s3/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "ef99f5f49ac65fe48f87d514ea751cb0c908126b0a6f45862b4525727bdb73dc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "472742ebe74334f17c45088271199514a6ed5b94f7bdd0196c45b27b5c56d75f"
    sha256 cellar: :any,                 arm64_sequoia: "43f1a5ff249d373bbba2b184163701da61808912f4778c602eb6482086f9f2bc"
    sha256 cellar: :any,                 arm64_sonoma:  "042f8f7573adcd7558fa72068587573cd7d927c9a978144cabaca5f441f7a607"
    sha256 cellar: :any,                 sonoma:        "6ee5743c08491169ed0c6e65a14df4246eb9892654415d472a839049527cac46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6ea61d0a50d3a07e517aadfa161de54869bf8fb9f5a62910c488febd03c4a75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e124855c95f938412282c58c139271c7dcae83bb9cdb5800a566a3e39c871759"
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
