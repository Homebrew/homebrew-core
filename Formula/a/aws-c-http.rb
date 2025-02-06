class AwsCHttp < Formula
  desc "C99 implementation of the HTTP/1.1 and HTTP/2 specifications"
  homepage "https://github.com/awslabs/aws-c-http"
  url "https://github.com/awslabs/aws-c-http/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "63061321fd3234a4f8688cff1a6681089321519436a5f181e1bcb359204df7c8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6d266dcd6df0032ac8fdd77c3dab18c54781e3a7a61a5f4f3f4ec61aed2667ed"
    sha256 cellar: :any,                 arm64_sonoma:  "7b9df203ab1f15f6cb3647fb92e20df67b19cd99f7c903395890f23b29500b88"
    sha256 cellar: :any,                 arm64_ventura: "df75d76d06707e0074685e32dc2c280e4827cb08a3f33bdb9193a816f91b82f4"
    sha256 cellar: :any,                 sonoma:        "b6948ea1285419bf8cea2c5f465843cf43bfd1f0d516fc7d249c776a4b71feca"
    sha256 cellar: :any,                 ventura:       "1f7eb7367de122560a51160df3c43b4907d1fca8cd954b7e420d88d6d58b5741"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f91b24e8b66b70d5ddaa1a307aa04e0773d21d837c5bb45024c8e1d5d77d7e3"
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
