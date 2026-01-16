class AwsCHttp < Formula
  desc "C99 implementation of the HTTP/1.1 and HTTP/2 specifications"
  homepage "https://github.com/awslabs/aws-c-http"
  url "https://github.com/awslabs/aws-c-http/archive/refs/tags/v0.10.9.tar.gz"
  sha256 "472653537a6c2e9dbf44a4e14991f65e61e65d43c120efe2c5f06b7f57363a2c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4a1a32963a282df527d5b3e7a4c03d54ad0e4d4fcddc656a26e95bf55d64069f"
    sha256 cellar: :any,                 arm64_sequoia: "ca7f30da0961bfd0094f05c4bb640f8248dcafc296d3844ea37abb85d96cb2e6"
    sha256 cellar: :any,                 arm64_sonoma:  "dd329cc0e85de0fc803bddff67452f2a43f9086154f3841c7330767121ae8caf"
    sha256 cellar: :any,                 sonoma:        "d275d7ea1712ea365d8c0b185611896761ab2b7af51afd2701b0ce80f489e4b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b76e7ca5ba0391371715875bcf34bd0074d172bda6d93fc5439fe36f521905ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0127bb2b11cb8968bd5d92b64eac9b594ba78628968f0cc2c20aac9c6f243c34"
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
