class AwsCAuth < Formula
  desc "C99 library implementation of AWS client-side authentication"
  homepage "https://github.com/awslabs/aws-c-auth"
  url "https://github.com/awslabs/aws-c-auth/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "aa6e98864fefb95c249c100da4ae7aed36ba13a8a91415791ec6fad20bec0427"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "06df88080fcfaf6fe91a2c540b871a0c77a141ae1dbe8b73668e03eb55d0b67e"
    sha256 cellar: :any,                 arm64_sonoma:  "0c3c13ae6687460c5f29617c7c486260d3bc39cc7a496cde5daa2f3c36e42dd4"
    sha256 cellar: :any,                 arm64_ventura: "cf5e60be0f03a5525711c583ffd9c493a04a98e4826761cfd5ff14545ab8b69e"
    sha256 cellar: :any,                 sonoma:        "49dfff5ac5771443df5b68926932e75f0a40a16843b4178ffcbac5112321142c"
    sha256 cellar: :any,                 ventura:       "c317c5c9f21dfac42f85f26189bae9b63dc40930e013c18a56eb9b50318ce2b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75e6ac9faec17da32024b9facb7f1ff8ab418e069d3657ee98c3e73a96202384"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ad423d2062cee09491d1c0fcdbf1f9699bdaa65ec2072552108fa0ce2070f3f"
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
