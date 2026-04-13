class AwsCHttp < Formula
  desc "C99 implementation of the HTTP/1.1 and HTTP/2 specifications"
  homepage "https://github.com/awslabs/aws-c-http"
  url "https://github.com/awslabs/aws-c-http/archive/refs/tags/v0.10.14.tar.gz"
  sha256 "d44866920b89e07b9db17e9c84587c6dca6c796d691597f1bee5e17b16b79d39"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8072d1d43d309391d240b05436c5c9d6db3f40cb916b893b65ddce1ab45aac85"
    sha256 cellar: :any,                 arm64_sequoia: "5576ca26a3ecf6140b8d493e088859bf49857b039f5d929a17a3b6978823a8a7"
    sha256 cellar: :any,                 arm64_sonoma:  "cabe8a22be59ac78a7889f75d2afb55659a340b2c2f95944744df111e2360cf1"
    sha256 cellar: :any,                 sonoma:        "494d511ac2bb9f03548d06da716e3304dcfbb3e31dee02e1df2f9c903c63b415"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a451841db84f7ee291bbf6cea4c0b37899e40aaffe06c5ffa9bf5d076165722"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4291688f0fa62cee8647306675bc209f9d2af1fff8fb6c4c0a2b4b852b483a33"
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
