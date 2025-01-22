class AwsCAuth < Formula
  desc "C99 library implementation of AWS client-side authentication"
  homepage "https://github.com/awslabs/aws-c-auth"
  url "https://github.com/awslabs/aws-c-auth/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "15241d7284aa0ac552589b61d04be455413af76fb2e1f13084a784a41f5faee5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dd17fa84772737aef6d36e53b3359078dd908c040166a3111a7864ad0c35b7cb"
    sha256 cellar: :any,                 arm64_sonoma:  "2b3a1e15bb2f3ce6b00b973a6ca0a2d00400bd2c82ca11bfb0a71cb69b430927"
    sha256 cellar: :any,                 arm64_ventura: "d0e8f8d09808d5598c4315ce9f18478ed55f67b2fb9953ff7c32cccc853af601"
    sha256 cellar: :any,                 sonoma:        "944b5b65af067396b4d97e8fc460289e1d81967ecd0ef2d1402dd776d48b41ba"
    sha256 cellar: :any,                 ventura:       "8688b9b3ddf2b54c4e96c794dee37078b8693d089a6977bcf7b74fc9b0135cef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7bad3db0dc215fe6e1ec3e9c193878283b22a37d18968be394405bf2b0fed6b"
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
