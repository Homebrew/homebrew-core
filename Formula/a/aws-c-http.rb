class AwsCHttp < Formula
  desc "C99 implementation of the HTTP/1.1 and HTTP/2 specifications"
  homepage "https://github.com/awslabs/aws-c-http"
  url "https://github.com/awslabs/aws-c-http/archive/refs/tags/v0.9.7.tar.gz"
  sha256 "18cb2a19a7cd80eafc4c29e6845ec97135a381a1e32fc848bdb8340cc747204a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bd52580d79559ecb0e3feaa0efb95d546e3bc62da9b38ea71fead17047b92985"
    sha256 cellar: :any,                 arm64_sonoma:  "35ed85d5397397d42165ab7d0fdf3f738b628690bbac986e16d9e7f63252a3e4"
    sha256 cellar: :any,                 arm64_ventura: "e051a3f58494515746b63fd532cbfb53703c2e8b5537959e1563770b64fe193a"
    sha256 cellar: :any,                 sonoma:        "5f945ee41b09a66b3a97f0f1f9e4569271922eaf664e0e310666e95bb5095c63"
    sha256 cellar: :any,                 ventura:       "0ff33b588d5cd2fa8884dbdbb34d25a3993b1251577eb3ead008f5c1bf25cca6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e655d09397d59cb910966c0cbf71c4a91412ab1afbd9dd444974822ec66807ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "734e5689a38f47edd4eaca919f7f4550d86c355de80ddee47bc4a284c9ad1e33"
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
