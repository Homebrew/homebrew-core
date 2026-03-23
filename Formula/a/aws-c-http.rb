class AwsCHttp < Formula
  desc "C99 implementation of the HTTP/1.1 and HTTP/2 specifications"
  homepage "https://github.com/awslabs/aws-c-http"
  url "https://github.com/awslabs/aws-c-http/archive/refs/tags/v0.10.12.tar.gz"
  sha256 "3d95f7aec670a2f58ab2dac59d9c9bf10dab36b67162e75b7a3c7dbb4ac635ea"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "29b809b9953c0c07931a643a1ba7be2bc98e5eb5834e842f962b706bedc1748f"
    sha256 cellar: :any,                 arm64_sequoia: "3001aa573ff271e9a06fb47d53ef41c90fdcf23e34f35480c85f403292f61e19"
    sha256 cellar: :any,                 arm64_sonoma:  "ccc866e341900aaf7b4bc60a31c81aaa8e5a68139baa1ee29a96c6c45f4a2618"
    sha256 cellar: :any,                 sonoma:        "1d94df91372d0965b1a6300f6c4eb8c25fe6e2601123ffa29531b4ffb7ea9c43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f976f39c8ed816983719a1a08406bab0a9a0faacddc413edc25161053da50a6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8682cfca145cca3d0c2491cfad82a1d3e16b8443f1412623ade07c7668c1026c"
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
