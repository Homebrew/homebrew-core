class AwsCHttp < Formula
  desc "C99 implementation of the HTTP/1.1 and HTTP/2 specifications"
  homepage "https://github.com/awslabs/aws-c-http"
  url "https://github.com/awslabs/aws-c-http/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "1550f7bf9666bb8f86514db9e623f07249e3c53e868d2f36ff69b83bd3eadfec"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9c62bac1870464c899f51ea35594c42b899c984ca0ef024ff8b940accd47208a"
    sha256 cellar: :any,                 arm64_sonoma:  "3ef352a205052d81964cb755837485467b4d38f7919f3311e540002fbb8749b7"
    sha256 cellar: :any,                 arm64_ventura: "94fffcd8914b2d240343ec248aa2570d67616a5da55410f7db9db5bf2f18112f"
    sha256 cellar: :any,                 sonoma:        "583fd37b1b5d315e0762cf09d6d7c7914497fc689bf18871e91d30615b33e871"
    sha256 cellar: :any,                 ventura:       "3f63fd6f3350754cecf0b8b49c29163ff6b15cebc1c7faab73b6ff5bb14d94e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fcd2423f617f91732e80d125bbed04c661a655fcd3676f515d509c63c83ead7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fad1d2a8092a5ce2edf330aceba0be19fe4005f439db68f683e2089f4ad50de"
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
