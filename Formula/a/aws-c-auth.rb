class AwsCAuth < Formula
  desc "C99 library implementation of AWS client-side authentication"
  homepage "https://github.com/awslabs/aws-c-auth"
  url "https://github.com/awslabs/aws-c-auth/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "217a0ebf8d7c5ad7e5f5ae814c2a371042164b64b4b9330c1c4bb2c6db1dbd33"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f0e670a32f6332167df1da92300073e615ada5d97c3eb521749a90a8ad43f455"
    sha256 cellar: :any,                 arm64_sonoma:  "b0f3c85c9c911a7ce9d6900a15906e6db65759d4dbc07f4080ea77c8adf70657"
    sha256 cellar: :any,                 arm64_ventura: "c9fefe246aea02390515230b9db840099bebaf70de69ed01a75a31429f57b36a"
    sha256 cellar: :any,                 sonoma:        "d24ada67482431127dfbf8073d2e32b5eba77b1a9ba02f0331604cbbd27f7c1d"
    sha256 cellar: :any,                 ventura:       "d3466a15deda7825361c58485c83a02ee0edfa8880ca27aede5a388386b164c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71003d289a501c8e20696aac4cef02b4edca469f38eff38fafe5a0c84f75c296"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-cal"
  depends_on "aws-c-common"
  depends_on "aws-c-http"
  depends_on "aws-c-io"
  depends_on "aws-c-sdkutils"

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_MODULE_PATH=#{Formula["aws-c-common"].opt_lib}/cmake
    ]
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
