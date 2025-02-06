class AwsCAuth < Formula
  desc "C99 library implementation of AWS client-side authentication"
  homepage "https://github.com/awslabs/aws-c-auth"
  url "https://github.com/awslabs/aws-c-auth/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "5a49b43aba7d2be6217b73dc40256120d31a7d0ca2c3f96d06e5154beed5de7a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ea8f529c6805d1dc5e6e4275f4266a68f5469d56d02c4b89426ad5ae04a13985"
    sha256 cellar: :any,                 arm64_sonoma:  "954010ff4c5f3e3cb9c2dcc9f0ce2da85aa0fbdc394cf94127648a8394c00aea"
    sha256 cellar: :any,                 arm64_ventura: "f1a67c235b86146bf506acdccfde0caa76856920a3fe0c70b0f0f5a141e0304d"
    sha256 cellar: :any,                 sonoma:        "43a2b308c057674cd8e80ea296e7662a107b7606d978f0c3e8623bf89b1534e1"
    sha256 cellar: :any,                 ventura:       "2d183a88c922c592567124ec7751a5108c66bb7ade4e0a1f217f09d41fa0c520"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6c936a0e642008e33d813b0954f386501f5f8520475de22f12d5a01f60e5d0a"
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
                   "-L#{Formula["aws-c-common"].opt_lib}", "-laws-c-common"
    system "./test"
  end
end
