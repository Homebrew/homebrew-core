class AwsCAuth < Formula
  desc "C99 library implementation of AWS client-side authentication"
  homepage "https://github.com/awslabs/aws-c-auth"
  url "https://github.com/awslabs/aws-c-auth/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "c3accbe5df51610a320de103c18f16efa17fc7269e0bdbe5ef093b14671f9f6c"
  license "Apache-2.0"
  revision 1
  compatibility_version 3

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "85b0afa9e796e8a6b76a09b900392aeac7af5ef0db9222d91a5b0782c2f08f8e"
    sha256 cellar: :any, arm64_tahoe:       "a605a2588caa6b1a8a9f98685c707022f001db3134ed571b44ffc749f2432322"
    sha256 cellar: :any, arm64_sequoia:     "60f53cb85cecfbc84174bdee5e876b2060809bf18f4709804000fb99d9824a86"
    sha256 cellar: :any, arm64_linux:       "134f3fa540c66b82e374e7e7122072349733178aaae065ba61b1795cfe70158a"
    sha256 cellar: :any, x86_64_linux:      "d8f716b6894965ad225585d6dbee2d2be24c34d2258b00e80161ba09c5e43996"
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
