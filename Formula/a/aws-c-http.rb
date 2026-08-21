class AwsCHttp < Formula
  desc "C99 implementation of the HTTP/1.1 and HTTP/2 specifications"
  homepage "https://github.com/awslabs/aws-c-http"
  url "https://github.com/awslabs/aws-c-http/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "2988843d5c95d92249d40e59480c2a4376533a91d8e38a5106dc4da5a8720ce5"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e386bf876e2c9a818dcbd5e469e933db66d3b04a45b72241498139a55446db73"
    sha256 cellar: :any, arm64_sequoia: "cae2cb4f557374b37f5c16c06514beab53c5c0efca8b2d6b88141d7619e09e6d"
    sha256 cellar: :any, arm64_sonoma:  "a0dbe5ecd8fb8dd0376849895f7e81cd6c23c4f75d907f2542313ea720b59673"
    sha256 cellar: :any, sonoma:        "c47e442b1a24dc7081538707156f0d95107269e6d461df257ac256339bb13c34"
    sha256 cellar: :any, arm64_linux:   "810dfa3569a76d47f3147eff4643709f2337e8eec7e5d62fe28748771182eff1"
    sha256 cellar: :any, x86_64_linux:  "e37533670098a93a153822b3d1af29883400a88aeb21d89e9dbb9009a55cde11"
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
