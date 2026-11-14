class AwsCAuth < Formula
  desc "C99 library implementation of AWS client-side authentication"
  homepage "https://github.com/awslabs/aws-c-auth"
  url "https://github.com/awslabs/aws-c-auth/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "5d4c4c7ab2d9c11be31b202b645d0bb4739257a7b4b7d03a264ff5b9bb4a6f6f"
  license "Apache-2.0"
  revision 1
  compatibility_version 3

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8483e3e3a3cd5a6ec637cbe1449786516a578a129afadd7faf499419d2870e1e"
    sha256 cellar: :any, arm64_tahoe:       "e6415012b5677908f78ed73f784d378c46fd32fa424d5483aef56e042cef84bc"
    sha256 cellar: :any, arm64_sequoia:     "836c62cbbba13099c6c82a44db48d0925d22be0a3de2ef78719802d7dc2a6327"
    sha256 cellar: :any, arm64_linux:       "d528800babca7e9e1a3fb969d96a5227e39fa32d2488847d915ab3609589295e"
    sha256 cellar: :any, x86_64_linux:      "1514a822f93c2545b0952865e1dcaefa4caf355ea62dcf72d3d1d57995c07361"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-cal"
  depends_on "aws-c-common"
  depends_on "aws-c-http"
  depends_on "aws-c-io"
  depends_on "aws-c-sdkutils"

  deny_network_access!

  def install
    args = ["-DBUILD_SHARED_LIBS=ON"]
    # Avoid linkage to `aws-c-compression`
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <aws/auth/credentials.h>
      #include <aws/common/allocator.h>
      #include <assert.h>

      int main(void) {
        struct aws_allocator *allocator = aws_default_allocator();
        struct aws_credentials *credentials = aws_credentials_new_anonymous(allocator);

        assert(NULL != credentials);
        assert(aws_credentials_is_anonymous(credentials));
        assert(NULL == aws_credentials_get_access_key_id(credentials).ptr);
        assert(NULL == aws_credentials_get_secret_access_key(credentials).ptr);
        assert(NULL == aws_credentials_get_session_token(credentials).ptr);

        aws_credentials_release(credentials);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-laws-c-auth",
                   "-L#{formula_opt_lib("aws-c-common")}", "-laws-c-common"
    system "./test"
  end
end
