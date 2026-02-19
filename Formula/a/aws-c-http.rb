class AwsCHttp < Formula
  desc "C99 implementation of the HTTP/1.1 and HTTP/2 specifications"
  homepage "https://github.com/awslabs/aws-c-http"
  url "https://github.com/awslabs/aws-c-http/archive/refs/tags/v0.10.10.tar.gz"
  sha256 "4590538bb42a2b1f66fbae9f2ff867fb13e404e5565cdfa7d0a8af5a8258f8f6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ace90cfcd0130c365db116f24d30d8eb4397dcb5e176899e313a821b2f252416"
    sha256 cellar: :any,                 arm64_sequoia: "55761cc3c5d06ef60b34ac286559378e02f5921df36709293df15420549319f1"
    sha256 cellar: :any,                 arm64_sonoma:  "c9632cec638ec40651411d6b93e018c447f438db569805fbe9f31c84286b39c2"
    sha256 cellar: :any,                 sonoma:        "b651e3fe29af79bc36610cd0a9eb00369ffe6d056f4810eefcfed0dbcc6ee996"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d95270c3c8fd69252049b7708ea04340ba6a79cee84cdc8a88fe06eb059594c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38a6265e9e4bf45c96836fbb5512497dca9d32d29d1fe588b11d734da8b75534"
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
