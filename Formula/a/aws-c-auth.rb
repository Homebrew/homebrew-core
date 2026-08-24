class AwsCAuth < Formula
  desc "C99 library implementation of AWS client-side authentication"
  homepage "https://github.com/awslabs/aws-c-auth"
  url "https://github.com/awslabs/aws-c-auth/archive/refs/tags/v0.10.5.tar.gz"
  sha256 "1ddd1dc476debdbf9ff083e254396fdc3ea0846dccf7d5f983a6571303abcb35"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d3c8d5251398ca01698394870e24d006a6abe0fbc51a99f4e8c81a3e31dc8ede"
    sha256 cellar: :any, arm64_sequoia: "e90490245eb7f773d09ede50c82048e893aebec1eda5cc15c7cf452d6661c1c6"
    sha256 cellar: :any, arm64_sonoma:  "f56625f98a73863dd947db9d2264e0ef1f81211bb23d61e9f7396b9db6ce8553"
    sha256 cellar: :any, sonoma:        "0239ad31fda55b5af7f55ffa6fcd51e717e04578faa0e89a7dd3fcd66f9f2110"
    sha256 cellar: :any, arm64_linux:   "8725053e5ce36a34b717aa80a2a2fd5cf0f89289b3b6737744289698528fed4b"
    sha256 cellar: :any, x86_64_linux:  "18d975d6b16ad41b63213a76df28f437be73d189e71f96887569456fb4cb72ef"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-cal"
  depends_on "aws-c-common"
  depends_on "aws-c-http"
  depends_on "aws-c-io"
  depends_on "aws-c-sdkutils"

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
