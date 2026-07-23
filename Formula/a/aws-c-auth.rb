class AwsCAuth < Formula
  desc "C99 library implementation of AWS client-side authentication"
  homepage "https://github.com/awslabs/aws-c-auth"
  url "https://github.com/awslabs/aws-c-auth/archive/refs/tags/v0.10.4.tar.gz"
  sha256 "6fb567f496a450d4b6d3f5749d735977a0156957e8ccbca9af7a5ee15d1ffda7"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2d018df6b8d88533d32b03980c628a8eb7e480059f2fef34aa23e3f00284e68f"
    sha256 cellar: :any, arm64_sequoia: "b8212e594ef0c35dd7b1e2c69ea872bab68bbc28d125f495e33adf4ad7bd3a61"
    sha256 cellar: :any, arm64_sonoma:  "bebc572102eb7fd505566a01b303f429b8cc715390ccca3885ac9053fd1c9356"
    sha256 cellar: :any, sonoma:        "d5ca270cfc63e54354311ba8cc0375a779de1b6208e64e5cba6cf94d78c4ff65"
    sha256 cellar: :any, arm64_linux:   "ea7be4caad5462ea19365a0fc2c04bb5ed271fcfb415773300731d718d98db16"
    sha256 cellar: :any, x86_64_linux:  "4e41ef15d569049d814d1137f9415a7732c32ff6e99339dda8a179165c06702f"
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
