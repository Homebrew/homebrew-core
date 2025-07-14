class AwsCHttp < Formula
  desc "C99 implementation of the HTTP/1.1 and HTTP/2 specifications"
  homepage "https://github.com/awslabs/aws-c-http"
  url "https://github.com/awslabs/aws-c-http/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "048d9d683459ade363fd7cc448c2b6329c78f67a2a0c0cb61c16de4634a2fc6b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f1bca526352938e70ece279950a546502122f759333350fe51151da7fd7106e8"
    sha256 cellar: :any,                 arm64_sonoma:  "e9891d1a3034889c0427ce1adfd7450c09a57761c0b1d616473fc158be6d494f"
    sha256 cellar: :any,                 arm64_ventura: "d2f3af7b128716770219488bc0ce00484f90f3df815705c0d8cc1e41ff8f0a46"
    sha256 cellar: :any,                 sonoma:        "b4644fba2860259fece65243d4a5b6db055b8ee3113a8b9c0a2a8baef5469d2a"
    sha256 cellar: :any,                 ventura:       "89b0dde09ebcd5d5e38086a843b18208da3fcb2a16ee9609bc7ae276070e83cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "364ce514770a65b693c58ba693b80cc5a0607887da291c7c9afc2957f97672b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f34e3620074a106822b5766d28d0e72481fc79369c94c20e80edd79a9559100"
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
