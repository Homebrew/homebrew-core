class AwsCS3 < Formula
  desc "C99 library implementation for communicating with the S3 service"
  homepage "https://github.com/awslabs/aws-c-s3"
  url "https://github.com/awslabs/aws-c-s3/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "26bac413daa8b4146abd1fceb55a282a5d3869524c24aca64a00ec1a4e0449bd"
  license "Apache-2.0"
  revision 3
  compatibility_version 8

  bottle do
    manifest_sha256 "3878c8f2ede92c52caaf59b9ae007306fceb5e186fda6a55c78b3d6cfca57bbc"
    sha256 cellar: :any, arm64_golden_gate: "782132cca969a405555ab9d617c28ddbbe8b7bb4d703f3b604636f97080a2427"
    sha256 cellar: :any, arm64_tahoe:       "d705d805c747af9f6c2d16a59a6343741f4e18f7d6227aa234392146770418fd"
    sha256 cellar: :any, arm64_sequoia:     "27eb75e043725c545249aaa15af4e6f0b1a93e2e49147dc64e78be9da29ca416"
    sha256 cellar: :any, arm64_linux:       "33feb77b5dc65cd971739f91461337ebabfc0ed7123da64e6f556e95b5bce3f2"
    sha256 cellar: :any, x86_64_linux:      "689a4bd3d6445c1de332b447b4420182a9a79dc0529fbc357900e382a309eebf"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-auth"
  depends_on "aws-c-cal"
  depends_on "aws-c-common"
  depends_on "aws-c-http"
  depends_on "aws-c-io"
  depends_on "aws-checksums"

  deny_network_access!

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
