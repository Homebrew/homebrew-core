class AwsCHttp < Formula
  desc "C99 implementation of the HTTP/1.1 and HTTP/2 specifications"
  homepage "https://github.com/awslabs/aws-c-http"
  url "https://github.com/awslabs/aws-c-http/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "f7881e2f9af1a2e114b4147be80d70480f06af2b9cd195e8448afb750c74b1ae"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7b158af0924aef33bf85deb6cd7d6c74de111815a23b62bf8dcee66b52dc012e"
    sha256 cellar: :any,                 arm64_sonoma:  "2878db242f2c1d32394d23c1ec764a56226d888440244594bf62bce7a5b2427d"
    sha256 cellar: :any,                 arm64_ventura: "001bab5baca234a80df781ac27cceb4e2c48ef744666daf395249c34059dbfa6"
    sha256 cellar: :any,                 sonoma:        "6523663297d0cd6072b4927bcd4c46ce89ca4624b3153dbfec802a259b9f6d0d"
    sha256 cellar: :any,                 ventura:       "921f388ff5995ec8945264f5b352a5c1b66a55adb0a4a8b726876d8124842243"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09153c82d411d8cc6afc6c03963e8cd30b57690cb31df9f9c46ef3c13432e0e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0dab760e10b37c622eaf171361e52a86f8d709ab23e9a1a9f24f8333225b98a"
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
