class AwsCAuth < Formula
  desc "C99 library implementation of AWS client-side authentication"
  homepage "https://github.com/awslabs/aws-c-auth"
  url "https://github.com/awslabs/aws-c-auth/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "c3accbe5df51610a320de103c18f16efa17fc7269e0bdbe5ef093b14671f9f6c"
  license "Apache-2.0"
  compatibility_version 3

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6ef67f9715a98b53d239c46439d8d1516fcba6e32b3657b747a4c710165f7d35"
    sha256 cellar: :any, arm64_tahoe:       "97b8d5506f8e722ccc551dc7762b011bd2b61f6ff313c1f2b7f6b4f12503ef63"
    sha256 cellar: :any, arm64_sequoia:     "7fc91987ef8e801688f55623f58816ea77737a41d7228fa95fc66d2ac7d3af98"
    sha256 cellar: :any, arm64_linux:       "811a72e37687507a65c95764bdfcdd4921c333bfe6445f08245fc1180f2181fd"
    sha256 cellar: :any, x86_64_linux:      "863b2cfffe48d6c608c9f478f8f323316451c9e7a9cce154093e79e7da1f8308"
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
