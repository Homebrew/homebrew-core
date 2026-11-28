class AwsCHttp < Formula
  desc "C99 implementation of the HTTP/1.1 and HTTP/2 specifications"
  homepage "https://github.com/awslabs/aws-c-http"
  url "https://github.com/awslabs/aws-c-http/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "40cd2009ec16712384d7bfd70251ff29d93863499f25cab0dd5507af1e0023c1"
  license "Apache-2.0"
  compatibility_version 5

  bottle do
    manifest_sha256 "1392ad9e95870186ffa82c5ec9377f69e79df3b399cfe9d4eafbf4c981edad4d"
    sha256 cellar: :any, arm64_golden_gate: "eb9bf26818e53aadd2fbbc9ab12e40ea0ee3d5dde58cdea82d927cdfada94097"
    sha256 cellar: :any, arm64_tahoe:       "38929afbdefdde576d935d096bc80385de8eb088dbfdef391d0fe4900e84a9d4"
    sha256 cellar: :any, arm64_sequoia:     "cb8069bdb05f77c54e45392dca3a0fec94fed5389c124e5cf3cceee616c8d15f"
    sha256 cellar: :any, arm64_linux:       "a0c7d31140ac9c117f37da9e0d29a2ac58e5eb42d5d4f84461e6321cb894f2e9"
    sha256 cellar: :any, x86_64_linux:      "9cd25ebec41225a36b09c2b7bac6c3117c5f7a6ac18b8d09fea6aaa385fdf768"
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
