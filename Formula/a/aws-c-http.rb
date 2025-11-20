class AwsCHttp < Formula
  desc "C99 implementation of the HTTP/1.1 and HTTP/2 specifications"
  homepage "https://github.com/awslabs/aws-c-http"
  url "https://github.com/awslabs/aws-c-http/archive/refs/tags/v0.10.7.tar.gz"
  sha256 "ce9e71c3eae67b1c6c0149278e0d0929a7d928c3547de64999430c8592864ad4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a7f26111b34cc6e6166a7737110880ed463a6d72f461e3a11302b7458cade2f1"
    sha256 cellar: :any,                 arm64_sequoia: "75b4c5cc6cd8fde7631ef352fe6666f5ae435b694a4ce4e4afba8ef7ebde77e9"
    sha256 cellar: :any,                 arm64_sonoma:  "9fdcff12d1bab1a98886151a188f6d8762be0af17b96210e012870f4bad2779a"
    sha256 cellar: :any,                 sonoma:        "d823374276406d418b7e0e27054e8ae866c5e296fe86a28da7b841a87fe097b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85d29fcbddd521c73e19089230ec457b9f795aa0df2b95f909d586a98a08d39f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f257e6f5e39e906029d726bc8b8ff77ab6c7a616ab739368ebf828b934a601b5"
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
