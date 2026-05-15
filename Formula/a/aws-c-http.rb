class AwsCHttp < Formula
  desc "C99 implementation of the HTTP/1.1 and HTTP/2 specifications"
  homepage "https://github.com/awslabs/aws-c-http"
  url "https://github.com/awslabs/aws-c-http/archive/refs/tags/v0.10.15.tar.gz"
  sha256 "37e7f9806b2877671cfa2bde078c50b78a358f35ef5a07f7bd2ca1beab5b5a9f"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8c8a8ca771248b7f69d81de6c7be8f3e8fd0f3003ca7d66e292b705ee5fe58af"
    sha256 cellar: :any,                 arm64_sequoia: "574312858bd735a9cfbb6ba4c36d200e9cd4d46fc48afb4e61186a4406e33ad4"
    sha256 cellar: :any,                 arm64_sonoma:  "9a94584b974ef5d554c4daeed497d663ecbaa08b2f811b17db97d173f67e8008"
    sha256 cellar: :any,                 sonoma:        "9df78e1d462c0d187d8f1ccf5e823679b9b12d197fecdf3da8e83dee21180e05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffb572b52b008f24957ee7f738be9c302317002c2161d51095c54d11eb75475c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f0ce61834290c7eaa451d47b6f64d75791e23b3831815cc39125b38002f8d4b"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-cal"
  depends_on "aws-c-common"
  depends_on "aws-c-compression"
  depends_on "aws-c-io"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <aws/common/allocator.h>
      #include <aws/common/error.h>
      #include <aws/http/request_response.h>
      #include <assert.h>

      int main(void) {
        struct aws_allocator *allocator = aws_default_allocator();
        struct aws_http_headers *headers = aws_http_headers_new(allocator);
        assert(NULL != headers);

        char name_src[] = "Host";
        char value_src[] = "example.com";

        assert(AWS_OP_SUCCESS ==
          aws_http_headers_add(headers, aws_byte_cursor_from_c_str(name_src), aws_byte_cursor_from_c_str(value_src)));
        assert(1 == aws_http_headers_count(headers));

        name_src[0] = 0;
        value_src[0] = 0;

        struct aws_http_header get;
        assert(AWS_OP_SUCCESS == aws_http_headers_get_index(headers, 0, &get));
        assert(aws_byte_cursor_eq_c_str(&get.name, "Host"));
        assert(aws_byte_cursor_eq_c_str(&get.value, "example.com"));

        aws_http_headers_release(headers);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-laws-c-http",
                   "-L#{Formula["aws-c-common"].opt_lib}", "-laws-c-common"
    system "./test"
  end
end
