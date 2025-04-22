class AwsCSdkutils < Formula
  desc "C99 library implementing AWS SDK specific utilities"
  homepage "https://github.com/awslabs/aws-c-sdkutils"
  url "https://github.com/awslabs/aws-c-sdkutils/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "5a0489d508341b84eea556e351717bc33524d3dfd6207ee3aba6068994ea6018"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "93fd575ad824cfb25b0d99bd63ba802bf57f5c96cc819f430cb0e305ede0886d"
    sha256 cellar: :any,                 arm64_sonoma:  "d93a8e699dce0cca1ef87fde09b4438d5dcd0d8b25105b02670a8b0ed90fa023"
    sha256 cellar: :any,                 arm64_ventura: "342b24652cac5e4f854f6477ee33fbe21f09098632260b2cea671ee99f957e39"
    sha256 cellar: :any,                 sonoma:        "6ed10199d115287519157ebc4b866ee0450802ad706760dbf6739351229cc1ac"
    sha256 cellar: :any,                 ventura:       "5c5280da68e63344eaa93be23bb2ab6b63ff1c4c192212713d303413ed90c75a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "533800eab3e542e474b861824cdb7771fd21742707cd92cc628af138661991a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0ab4b00678163b075582a2b214667a44dc547ad17e0bd5314cd4d1ee0696dc9"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-common"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~'C'
      #include <aws/common/allocator.h>
      #include <aws/common/string.h>
      #include <aws/sdkutils/aws_profile.h>
      #include <assert.h>

      AWS_STATIC_STRING_FROM_LITERAL(s_single_simple_property_profile, "[profile foo]\nname = value");

      int main(void) {
        struct aws_allocator *allocator = aws_default_allocator();

        struct aws_byte_cursor contents = aws_byte_cursor_from_string(s_single_simple_property_profile);
        struct aws_byte_buf buffer;
        AWS_ZERO_STRUCT(buffer);
        aws_byte_buf_init_copy_from_cursor(&buffer, allocator, contents);
        struct aws_profile_collection *profile_collection =
          aws_profile_collection_new_from_buffer(allocator, &buffer, AWS_PST_CONFIG);
        aws_byte_buf_clean_up(&buffer);

        assert(profile_collection != NULL);
        assert(aws_profile_collection_get_profile_count(profile_collection) == 1);

        struct aws_string *profile_name_str = aws_string_new_from_c_str(allocator, "foo");
        const struct aws_profile *profile = aws_profile_collection_get_profile(profile_collection, profile_name_str);
        aws_string_destroy(profile_name_str);
        assert(profile != NULL);

        aws_profile_collection_destroy(profile_collection);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-laws-c-sdkutils",
                   "-L#{Formula["aws-c-common"].opt_lib}", "-laws-c-common"
    system "./test"
  end
end
