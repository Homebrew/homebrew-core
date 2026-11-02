class AwsCAuth < Formula
  desc "C99 library implementation of AWS client-side authentication"
  homepage "https://github.com/awslabs/aws-c-auth"
  url "https://github.com/awslabs/aws-c-auth/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "c3accbe5df51610a320de103c18f16efa17fc7269e0bdbe5ef093b14671f9f6c"
  license "Apache-2.0"
  compatibility_version 3

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8a49c8ba90483e1cf818fe63210aea252fc27d554d4c71ae1348a73451289881"
    sha256 cellar: :any, arm64_tahoe:       "51b6ad399310aff27ffd1274cb969629ced78f7d5e7ac0624aed76c77a2f9dd3"
    sha256 cellar: :any, arm64_sequoia:     "29e3956178e26914e3fa0a7215619d629e0dff316b3ee9fdbfe2d97876668d32"
    sha256 cellar: :any, arm64_linux:       "2111615bb36e80eee142fd238fdc438fd37134bd1cdec7696417b6f7484d3bcc"
    sha256 cellar: :any, x86_64_linux:      "8f0bac182bf3b1a069a1154009512866d182101a96fa01403a37bc1f8cc8cd59"
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
