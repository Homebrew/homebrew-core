class AwsCAuth < Formula
  desc "C99 library implementation of AWS client-side authentication"
  homepage "https://github.com/awslabs/aws-c-auth"
  url "https://github.com/awslabs/aws-c-auth/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "20fc5e75529fadd81fd38b25f9d83798b53ab235ebbac92cdfbb716cfcc7593d"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "515ba990b93f205110dcb04357bea20db861b8f604bddd909248578795783216"
    sha256 cellar: :any,                 arm64_sequoia: "6887071637913cbacc73eef093cd418fd814eab95c8aa3df43881c310ee8b923"
    sha256 cellar: :any,                 arm64_sonoma:  "0c62b66b6eda70a2ea0f156cf83bc92b30cb743c7270c48e9a45f93a07d61c95"
    sha256 cellar: :any,                 sonoma:        "95063b64ac8073c212fc74dc81ee826e501fd66a01daa9a477a9f2302c06f1f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd06b08b83802a46621f0e5e335c09bf82c4d4ad09118ddc23e0fa007d1860f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b05ef257dcda9e66663a101393802d8e93538b07a80bfb1bbcf8454f13ce8b82"
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
