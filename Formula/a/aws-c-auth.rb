class AwsCAuth < Formula
  desc "C99 library implementation of AWS client-side authentication"
  homepage "https://github.com/awslabs/aws-c-auth"
  url "https://github.com/awslabs/aws-c-auth/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "adae1e725d9725682366080b8bf8e49481650c436b846ceeb5efe955d5e03273"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8a9ee4a866559d4b733e584ce1df655cc789f10507ea99e8cb4442d97bc11d42"
    sha256 cellar: :any,                 arm64_sequoia: "628d7eff28d87830f9e3b8930a07db8786efd86566f7b861c1dad714a3628c04"
    sha256 cellar: :any,                 arm64_sonoma:  "76e5d44197370eec47d2c553734288f1b1e167af6fe2725845eaed05949d849f"
    sha256 cellar: :any,                 arm64_ventura: "6dbf23930d544c6aecb07e2c14cb68dfc16cef447d888d726320a555b2883004"
    sha256 cellar: :any,                 sonoma:        "6254f9445b56eef471bf35b06b14f731d37834febf83c581b88a58550a607750"
    sha256 cellar: :any,                 ventura:       "fd056f07750e90ab5f3b4871b401b4c28095ff1cede75da681547aeb2f4628bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "166b119a65f5f27402543f2b16167514f99d29f66980af5f98ced0085a122f26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "631d5a1f2d684dcbf46bbe001ec463e64ab543e894c10a5aa1e06db6bbf6b7ba"
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
