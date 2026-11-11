class AwsCAuth < Formula
  desc "C99 library implementation of AWS client-side authentication"
  homepage "https://github.com/awslabs/aws-c-auth"
  url "https://github.com/awslabs/aws-c-auth/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "5d4c4c7ab2d9c11be31b202b645d0bb4739257a7b4b7d03a264ff5b9bb4a6f6f"
  license "Apache-2.0"
  compatibility_version 3

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4ea9e63af544fe0a50056167c314cfcb155118a9c9230c4107ffd6721f9384b5"
    sha256 cellar: :any, arm64_tahoe:       "e9ff69549cd9a6ed6723f472f1771ae8fac35d522941e7993adc7f9ec5c68e06"
    sha256 cellar: :any, arm64_sequoia:     "a04820cfcbaa24ed3286f47f26d4c801c9465580d25ff7389ee92c350ea19a18"
    sha256 cellar: :any, arm64_linux:       "f2f2c3418aaf6fe374bc13e62c80a6c35d44d5b392562854b3430e5884037af7"
    sha256 cellar: :any, x86_64_linux:      "b847ab95d3f5735970891beff9a3b7d667b93c6a69218d663cde9a47773a5206"
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
