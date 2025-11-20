class AwsCS3 < Formula
  desc "C99 library implementation for communicating with the S3 service"
  homepage "https://github.com/awslabs/aws-c-s3"
  url "https://github.com/awslabs/aws-c-s3/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "cc656740e8e566b5c0233b1e96c8a91fc10d31872b3fcea6831c57902a746386"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3509b6b11d4dabaaea1015297b5d8e517c838e52d7f7edcbff5c55b323d1f74c"
    sha256 cellar: :any,                 arm64_sequoia: "9533eda94ebc9dafadc6a201b0fb9e8eca786721e058695126416bb1e87889e1"
    sha256 cellar: :any,                 arm64_sonoma:  "27c94f9610d9b125c042f27df1fd61f61d50680278cdc88f109d1fdd17e77582"
    sha256 cellar: :any,                 sonoma:        "ff52fae2e2ab722c055ce0be93f89ef99905cf1ac22f36c067ee4c8e15fc48c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56ab4a2664a311f825cc4917782aca4ba593e3a5dee12c2d740a9f3de82a3452"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5097654a064b179072afd86d2815aac2176bbc72144e41b4046bc45bde07547"
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
