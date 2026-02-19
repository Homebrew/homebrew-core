class AwsCAuth < Formula
  desc "C99 library implementation of AWS client-side authentication"
  homepage "https://github.com/awslabs/aws-c-auth"
  url "https://github.com/awslabs/aws-c-auth/archive/refs/tags/v0.9.6.tar.gz"
  sha256 "2448e939d924731a891bec34f6da764d3a34afd52b9f5a3e614bb1bf96e6452d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6106e4003be5b3fab6629f7e8ff265d919fdc73857cf59629c5cec87185b9c9c"
    sha256 cellar: :any,                 arm64_sequoia: "f740b568eccea313e0857efa9eb189de96dd4a9575c13a4f8dac949f7d892c47"
    sha256 cellar: :any,                 arm64_sonoma:  "05553dbc1405d1b05ee2a95207eb41ba3aab80414e5ea72268b7e8b849fd7677"
    sha256 cellar: :any,                 sonoma:        "f5b6746e6ff042c8fcd805c469564e8b9593e5d23dc91f217f430c9c50f837f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5f973dd7836ca13bca6f0919b4e6d8873dc0510c0857148990e0452879a3af0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b50f2b7f80a0465e1392cdceafa539254cf8e1cf17633b878e08b50227365b12"
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
