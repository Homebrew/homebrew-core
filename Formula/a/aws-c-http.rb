class AwsCHttp < Formula
  desc "C99 implementation of the HTTP/1.1 and HTTP/2 specifications"
  homepage "https://github.com/awslabs/aws-c-http"
  url "https://github.com/awslabs/aws-c-http/archive/refs/tags/v0.10.4.tar.gz"
  sha256 "dfeeeaa2e84ccda4c8cb0c29f412298df80a57a27003e716f2d3df9794956fc1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8cca92c4d5086717f47b435e9c1e84326fe6b34da77cf85a2bc1f33dce23bb9b"
    sha256 cellar: :any,                 arm64_sequoia: "cec7565de8a08f245026dd494d762ba9ed18cdfa0a08c8c8014944de80f4eb27"
    sha256 cellar: :any,                 arm64_sonoma:  "c8ab8457cc2eaae759295a4c452948bd650e2273249f6e7b5945e5fe6ccf96c3"
    sha256 cellar: :any,                 arm64_ventura: "d2ed6fe9f71a60625198883937088f75d593463acc2dec9d5367a717f353568d"
    sha256 cellar: :any,                 sonoma:        "31f7e03f8a5188d2d8b8aa85121655f37d23531fbd7089d6fb25e70f7c073429"
    sha256 cellar: :any,                 ventura:       "e17a77fa18a8ae354e151bed64a409ac8d0d1461d38f25d40dc60eefd0f39820"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f5bbd9bb8d6f12afd2383d5ccb481d3eb421e292797c9db564cd1c249f35da6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "706cf08288b10399e760afefe971015f7ff847d5a39b08b6d1b316907b7bc6b4"
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
