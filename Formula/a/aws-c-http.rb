class AwsCHttp < Formula
  desc "C99 implementation of the HTTP/1.1 and HTTP/2 specifications"
  homepage "https://github.com/awslabs/aws-c-http"
  url "https://github.com/awslabs/aws-c-http/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "16452de1b6e88e526f29602879ee15e02f363561004c660f53696676cffa6981"
  license "Apache-2.0"
  compatibility_version 4

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "00ec54696534c37ae9f05c804c6dcc11784ade47366eae5e5334bd54c5da9835"
    sha256 cellar: :any, arm64_tahoe:       "a9f86a0576c8265ce9921d091d462b65e56191fffa9e813e632fd7df1e3d68a3"
    sha256 cellar: :any, arm64_sequoia:     "e593e2127c414f69ec0455c3eb0ee06fc4c7c1ce092258beaf8c6d9eddd34243"
    sha256 cellar: :any, arm64_linux:       "9a89f8197401f248ff4c25c1d0b724d23fc6d540bf312d0b48e66b689cd9bd40"
    sha256 cellar: :any, x86_64_linux:      "b4c5984a970d6f0f36ae36883951b727569d6f30cf789cb07c1b9ee81b323b62"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-cal"
  depends_on "aws-c-common"
  depends_on "aws-c-compression"
  depends_on "aws-c-io"

  deny_network_access!

  def install
    args = ["-DBUILD_SHARED_LIBS=ON"]
    # Avoid linkage to OpenSSL
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
                   "-L#{formula_opt_lib("aws-c-common")}", "-laws-c-common"
    system "./test"
  end
end
