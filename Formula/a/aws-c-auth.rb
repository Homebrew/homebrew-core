class AwsCAuth < Formula
  desc "C99 library implementation of AWS client-side authentication"
  homepage "https://github.com/awslabs/aws-c-auth"
  url "https://github.com/awslabs/aws-c-auth/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "1925c0032321969ccb1333d9cfdba1564d705e64c899265613c9d7841ba66cc1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4bf1422e005eb4926d780cf37e938e3e0681890d2e65a4d66316928e7d026676"
    sha256 cellar: :any,                 arm64_sequoia: "dc2942d73feb8cc6a83b4790084359e5e88587113da7dde98da852d6492233a1"
    sha256 cellar: :any,                 arm64_sonoma:  "b9189d3d9152dde707d50eb310a9987a5e9894fb50353eaf148c9a562ab2dc0d"
    sha256 cellar: :any,                 sonoma:        "0d928444dcc59c8e0079648798b80899bc19597684fb642f7562b6a285d028cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f59d1185787081ef4900499b1324e0cab9fda6a87250548011fc6ccdad8c5eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06544e8c4d3721e7ce100a15d48e3b6fc3aa1791af44e1c281523152ba970f2f"
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
