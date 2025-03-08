class AwsCAuth < Formula
  desc "C99 library implementation of AWS client-side authentication"
  homepage "https://github.com/awslabs/aws-c-auth"
  url "https://github.com/awslabs/aws-c-auth/archive/refs/tags/v0.8.6.tar.gz"
  sha256 "5f5df716d02a2b973ec685f1b50749b2e82736599189926817fbca00cfb194d7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "074462fdde6880f84c6f64cccfb9e69b8fd37f2b3f7669dcffd11988fc414363"
    sha256 cellar: :any,                 arm64_sonoma:  "dc8ce677453b961ae37656e7d6d715700e93e35f690f9ab02968e007cac77da1"
    sha256 cellar: :any,                 arm64_ventura: "7392f8164f8caaeb09bc4086941682bcd32740ba254074f246f7e0a44c35f4af"
    sha256 cellar: :any,                 sonoma:        "9c0948d17572d15d6ddd6d47c608b7a453dcb4e1a15ac95195ffde71f94c682b"
    sha256 cellar: :any,                 ventura:       "467b4cb4a753a852e5f2bdf6148cfcda1ce05b859c29bfbabbac9c32234dc793"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc87a17b0c8ffb399c8828d520c51ad4b0e7796f8757a317f6747e388978d3a4"
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
