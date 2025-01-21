class AwsCHttp < Formula
  desc "C99 implementation of the HTTP/1.1 and HTTP/2 specifications"
  homepage "https://github.com/awslabs/aws-c-http"
  url "https://github.com/awslabs/aws-c-http/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "328013ebc2b5725326cac01941041eec1e1010058c60709da2c23aa8fb967370"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3f3e7a0e5398811ea35d6630e5729328536bc76426d6730a3e5f515edf136076"
    sha256 cellar: :any,                 arm64_sonoma:  "266947765c842b1e323314ade182216c5b726e21880b3494c2ce3babbe504d32"
    sha256 cellar: :any,                 arm64_ventura: "e358788f7ac5f734fb6374499517ac2feab136279fc6725ccaf76c5d286c4574"
    sha256 cellar: :any,                 sonoma:        "842d551976597a6dc7ace9560920422f5f45f602e1a3ce2948b8decb161eb7bc"
    sha256 cellar: :any,                 ventura:       "a38183be37c398848ce30a6df991716430080abfd8b0d3232be6d47c80a36872"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6962c6a046821235a33de8a1dcf521e44b477a848d05a0e81c49be0480852f5"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-cal"
  depends_on "aws-c-common"
  depends_on "aws-c-compression"
  depends_on "aws-c-io"

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_MODULE_PATH=#{Formula["aws-c-common"].opt_lib}/cmake
    ]

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
                   "-L#{Formula["aws-c-common"].opt_lib}", "-laws-c-common"
    system "./test"
  end
end
