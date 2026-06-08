class AwsCHttp < Formula
  desc "C99 implementation of the HTTP/1.1 and HTTP/2 specifications"
  homepage "https://github.com/awslabs/aws-c-http"
  url "https://github.com/awslabs/aws-c-http/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "4ccbdd33c798b590288330dec9e93abe2ff6cfb198b7a4db036c9d362f2e6506"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b9149152c04c5c25c04caa686a8d43e0751f3e0cc6c20b8a8415e8eff9f3029f"
    sha256 cellar: :any,                 arm64_sequoia: "d2fff11d4a530964c0279fae924269b98a09bb9f6668ad3a2ad21db1b12c814d"
    sha256 cellar: :any,                 arm64_sonoma:  "bc57d165ad688254fa8285d010d581886302a09c7d1a3c2d7ea3cd2999e8e3da"
    sha256 cellar: :any,                 sonoma:        "cbbd735ddd8352efe23a14dcd3713d78b90e62802c78e28f94b18a6c52ee05e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c63ccfb3843bef764d993d953c7ad459ff7e0eaf9d1e271af49972b820a0b17f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80d1a904c01352c85247d261c592f3a1ab15a98086fe4b10750832bfb5f6ad4e"
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
