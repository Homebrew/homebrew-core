class AwsCAuth < Formula
  desc "C99 library implementation of AWS client-side authentication"
  homepage "https://github.com/awslabs/aws-c-auth"
  url "https://github.com/awslabs/aws-c-auth/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "12a29eb62c61cef4b38c90d4f0dd2657dc585a15c138d60941d6f20c1ad3b12d"
  license "Apache-2.0"
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "78862e5d32c2538c658bbf5d02b913bdc8941dd03b4ea56efa1df74f9db366ad"
    sha256 cellar: :any, arm64_tahoe:       "347f11c6e772a94298aff3463f3044e7234474018dca30a1d97eb0f2f8fdcde4"
    sha256 cellar: :any, arm64_sequoia:     "a9d57dbf4d39e117ab299795f3fc36e6e57c094630a371817fcdc1031f3dfc4c"
    sha256 cellar: :any, arm64_sonoma:      "ab507e68ea1ced21d87eb8d321628f357bc1b5399d6956b6d12f98b0ae1ad15c"
    sha256 cellar: :any, arm64_linux:       "3e6e970fc23afd5a33355ba4e77350852c89daee59de3594b2e8b7a0e50026ec"
    sha256 cellar: :any, x86_64_linux:      "5b8291ff7e841d525a8ee1b2ea16b15f6dd793f42aadf6ac7ba170a15e82d6a8"
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
