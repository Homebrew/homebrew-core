class AwsCHttp < Formula
  desc "C99 implementation of the HTTP/1.1 and HTTP/2 specifications"
  homepage "https://github.com/awslabs/aws-c-http"
  url "https://github.com/awslabs/aws-c-http/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "1540c7b51be730ee1efecabe2b6fc95c5021ab3458a8da98beb12bfd3e8eb6e9"
  license "Apache-2.0"
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "74ce77efc468e5805e2fe9e258daab7039d32a0e91e7d97979e97185e16a89c1"
    sha256 cellar: :any, arm64_tahoe:       "6bc3c7177e8f78095913f2dfcbe028b460f929745d7017d95f3c9de984c680d8"
    sha256 cellar: :any, arm64_sequoia:     "8d18ef448f6c62adc061dd5bbb066c7014e8c58cf7efe4f00066e65f282e8a70"
    sha256 cellar: :any, arm64_linux:       "49657a485d12958fd61f9fe294c44e4d270442361dd98211ba23179b18560d0f"
    sha256 cellar: :any, x86_64_linux:      "7a7b0371382f721b87448853ba2b4978b31cd6dab7c03cc9cd41d1a2380b8409"
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
