class AwsCAuth < Formula
  desc "C99 library implementation of AWS client-side authentication"
  homepage "https://github.com/awslabs/aws-c-auth"
  url "https://github.com/awslabs/aws-c-auth/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "faa8ac8aff348d5e69e4598a0e9a48efe049cd4410cec2a5988dcf68f6a14fd2"
  license "Apache-2.0"
  compatibility_version 4

  bottle do
    manifest_sha256 "4d1b4318d04ab07b3fc3199deed66e7343e64b319d5ae242b111478b5e25c2b6"
    sha256 cellar: :any, arm64_golden_gate: "29b29ef1f5ef00ce8a519d98a9eb6c2c4b3a98e9d662b87ff0f46e06598a415f"
    sha256 cellar: :any, arm64_tahoe:       "2bf4faea720e68e6872096269be4a196e6c439a329fd2da8102c7859835c3a57"
    sha256 cellar: :any, arm64_sequoia:     "a141cca313280000d2b667e7132a0940493a4036ded71170ceb8b20c2d6377f1"
    sha256 cellar: :any, arm64_linux:       "83f78203e64403e112ed77ad71fff3d013ef0b538ed5e3fb4413ac825f6e33cc"
    sha256 cellar: :any, x86_64_linux:      "911882fea242d359d53284b1eeae2e23059645f02f7a3585fe2ffb97f706cbbe"
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
