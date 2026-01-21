class AwsCAuth < Formula
  desc "C99 library implementation of AWS client-side authentication"
  homepage "https://github.com/awslabs/aws-c-auth"
  url "https://github.com/awslabs/aws-c-auth/archive/refs/tags/v0.9.5.tar.gz"
  sha256 "39000bff55fe8c82265b9044a966ab37da5c192a775e1b68b6fcba7e7f9882fb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e7c45b978984d2885f3a4713805f0984fa63aedaf6269f1d3cf3577a7780fcde"
    sha256 cellar: :any,                 arm64_sequoia: "cc69a9d3a4c795384e3cda5592831a75ee0acd7f18d104c181687da0db91dfe4"
    sha256 cellar: :any,                 arm64_sonoma:  "9aa91b0fb70bae7f1a285d1e1d01330cd0a7116504f1659af81710142ed98dfd"
    sha256 cellar: :any,                 sonoma:        "03a4e33c9ed6f5ea5b4df0574b82ea0809db86f9b0a29319110da128d2570ad4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf900bd6b2c495756fca082104170fb537d2d78b20ee37d62af3b95e6452bb3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f551712e1ecb0eb3cc43e23c7c77956f0373d5be1840372641a8195aacd24ec"
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
