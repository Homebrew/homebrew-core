class AwsCHttp < Formula
  desc "C99 implementation of the HTTP/1.1 and HTTP/2 specifications"
  homepage "https://github.com/awslabs/aws-c-http"
  url "https://github.com/awslabs/aws-c-http/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "ae992d9f24a88430cdd4b7538fab565e71faedb1f156f38d6a74f2a77269417f"
  license "Apache-2.0"
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "684b0e9021e6aaa598f61f6b5ea9a75cf3dc7bb3d08a082c1fd36d4925c1e309"
    sha256 cellar: :any, arm64_tahoe:       "e793734edac0279ac45a94f671363553fa9ffdb44c1f8d34b575cc188267367a"
    sha256 cellar: :any, arm64_sequoia:     "9440f33fae0b00ee12eb6c925d1c543e209cb0990b3a1dcd638fd08934b57f59"
    sha256 cellar: :any, arm64_sonoma:      "77b45ab0e61fdcfe2816c5852c877d9daceadc2743a48f5ef9c251ce608f596e"
    sha256 cellar: :any, arm64_linux:       "a664c1d2bdf74a5cd60b010e28c9116a6d1130b6391f37965522bdf9254f499c"
    sha256 cellar: :any, x86_64_linux:      "beb9558ddf4289a35d4b3f307d049c7da399f94634de0ef100661508d2546f8a"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-cal"
  depends_on "aws-c-common"
  depends_on "aws-c-compression"
  depends_on "aws-c-io"

  on_macos do
    depends_on "openssl@3"
    depends_on "s2n"
  end

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
                   "-L#{formula_opt_lib("aws-c-common")}", "-laws-c-common"
    system "./test"
  end
end
