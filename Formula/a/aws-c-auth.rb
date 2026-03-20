class AwsCAuth < Formula
  desc "C99 library implementation of AWS client-side authentication"
  homepage "https://github.com/awslabs/aws-c-auth"
  url "https://github.com/awslabs/aws-c-auth/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "85d737f0f735256f1931e85e4cadbe228d88698f7b59a9b390b49ef5d0778a43"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5c22d6769a7520e25ffa70a46af3e10473250d05c74a789905967406d7ab8258"
    sha256 cellar: :any,                 arm64_sequoia: "71053c5142fe1d79d35215247e8b098f30473c444704a9f7106387606b3f4cb7"
    sha256 cellar: :any,                 arm64_sonoma:  "7ae586ead74f0d5f0b24648d8297ce1acfc550326e281061c84047000954e59b"
    sha256 cellar: :any,                 sonoma:        "b1d8adbdf2074f37f166c394ed531d9552ed9d64b65257dfd09d52127b9280fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c87d38254911fab65d7bbb91a1e2767714b0bb7cf3fd7fd5ab084d00f86e544"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ca8253a6169e929833cd828c6b1dd5fe72280a6e98330841c8fdbb7ff297534"
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
