class AwsCHttp < Formula
  desc "C99 implementation of the HTTP/1.1 and HTTP/2 specifications"
  homepage "https://github.com/awslabs/aws-c-http"
  url "https://github.com/awslabs/aws-c-http/archive/refs/tags/v0.10.11.tar.gz"
  sha256 "b375e9630aa93830f54b544298745fd30a6cb3d09e5ff8473c7455a1599bf2b7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "64e5971a0754d25c08c7287032249bf1582adcb989f5a637622aef6d23fbadc2"
    sha256 cellar: :any,                 arm64_sequoia: "aab751a4f979acb2f7f4eb7f789720552053a991991c78a3953155281a6ba10b"
    sha256 cellar: :any,                 arm64_sonoma:  "0222e090f2a51c2a5b995789eea7be2f96c8cb4c7c827fead59ff18177c73d1b"
    sha256 cellar: :any,                 sonoma:        "db53c184d699037f93dc89346753d81069a4a4a8edbf81d71d52815e2cc05061"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf76693e9647fb211b043ed62fe5bd5cf55b82f64421b4542aa0680b69b49959"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11b559382e8ea301712450bbfb70a17d932a3658763305aa20726673ecbcca04"
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
