class AwsCAuth < Formula
  desc "C99 library implementation of AWS client-side authentication"
  homepage "https://github.com/awslabs/aws-c-auth"
  url "https://github.com/awslabs/aws-c-auth/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "88e1587d01fc6d172144453f72dca6f64920785b138ad383626f64ccfe85c686"
  license "Apache-2.0"
  compatibility_version 3

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9ef1a3d2aa019fe8be6f13d45a4a92d415d7491952d127056829d25dc35597af"
    sha256 cellar: :any, arm64_tahoe:       "182674bc8a0842ec141d83b926232e234d6c035d8a1b5debc09684745745d3a6"
    sha256 cellar: :any, arm64_sequoia:     "8de05a5135554a89f2650cb754b271279f85c14a79625783de101f96e020be5e"
    sha256 cellar: :any, arm64_linux:       "2226144e31c989973ebe7e2dcd43c117ed78035ab0ad0e0c5be49f3d3a394af0"
    sha256 cellar: :any, x86_64_linux:      "378def0cefb44a2ebac23403293e6dda36dfe0750b6cdeb46114626ba7aabde5"
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
