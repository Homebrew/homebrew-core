class AwsCHttp < Formula
  desc "C99 implementation of the HTTP/1.1 and HTTP/2 specifications"
  homepage "https://github.com/awslabs/aws-c-http"
  url "https://github.com/awslabs/aws-c-http/archive/refs/tags/v0.9.6.tar.gz"
  sha256 "39381e7b66d73b5dcf8b3afe533f3206349a7e8f0fb78c8bac469bee0f05b957"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "224d870b035b9ac18d3911ad89a3059f969e76244b0f0fd53b527590dd2474a3"
    sha256 cellar: :any,                 arm64_sonoma:  "72000f999dd8f477edc79ba766d44bb803ba0e8648d2621ea963c3612bfddb05"
    sha256 cellar: :any,                 arm64_ventura: "d215e7892cb8a7f2e526bb162a6009f3b04499096fe813613047cdd9f6461d79"
    sha256 cellar: :any,                 sonoma:        "142d53160595f48973cc696672ed1cfc2136e14b29181841a2b77150f44cccd6"
    sha256 cellar: :any,                 ventura:       "c76786c1bea2ab23d65313915c196fb9f83ee548bdb6286afe6baf02f6b76da6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1cef9d8ca4adec4df55a405704389b5ed5bdfc7ac0871419bed6f255a9a39d39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17fbfdcbe72e9edd0a08fafac2fdc5d72840bf78b7c9b60cf808f333d6e1900b"
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
