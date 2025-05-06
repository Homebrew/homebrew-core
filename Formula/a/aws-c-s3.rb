class AwsCS3 < Formula
  desc "C99 library implementation for communicating with the S3 service"
  homepage "https://github.com/awslabs/aws-c-s3"
  url "https://github.com/awslabs/aws-c-s3/archive/refs/tags/v0.7.16.tar.gz"
  sha256 "04c7edffd0210f8b0fd20be843ad74a350cb2edb37b47f99131136ec24a20e59"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "01fd8aae5750f3f0c1d5231f21cca99b048833ce20311aba92c82b3856c3b60a"
    sha256 cellar: :any,                 arm64_sonoma:  "aab944aa7282d9d452a6f1fc6879044ab7a2c9ab0f4bac732ecbc13ae1bbfd71"
    sha256 cellar: :any,                 arm64_ventura: "dc873ef3d045f00dd418e74250bfb07bccf2a95bc69adfcd849dbe8b2a1298b5"
    sha256 cellar: :any,                 sonoma:        "8369744f5afa8576e36d97387b7cd2f945c24425f9a191747d695f78e57dbe82"
    sha256 cellar: :any,                 ventura:       "f0c3d1ae8fd8410c04b172ac1db9775f75fd217992c79abcbd859e817b7cd4c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c93cca1e1e19fd806c639701dd133140a92b673f2fc3ee38ee2418e76f5474f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2240f83079b922843c71c5e751439b50f563baa986f71e9cb83ff8952405c6fc"
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
