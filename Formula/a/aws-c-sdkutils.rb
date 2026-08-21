class AwsCSdkutils < Formula
  desc "C99 library implementing AWS SDK specific utilities"
  homepage "https://github.com/awslabs/aws-c-sdkutils"
  url "https://github.com/awslabs/aws-c-sdkutils/archive/refs/tags/v0.2.10.tar.gz"
  sha256 "23bfb010c7a5becc48b7e36212a4f401319a46ec3e981eb9adb9d6b215e7a65e"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fb0e452e0d5fd368ebc13c604a4acda9bc81c905c66062d37a8c501b8122489c"
    sha256 cellar: :any, arm64_sequoia: "3473ca97c45b3386668aa8d5b3b3b24afc4bc8fa7a1c30f04195040e573f8400"
    sha256 cellar: :any, arm64_sonoma:  "24f208f492d6a867711415024a0f9552073342af72ffaf081635736a2ac803fc"
    sha256 cellar: :any, sonoma:        "9d906a80ed37da4082ffb6b6a2995498d395759749fbdf019ef3c8623b735018"
    sha256 cellar: :any, arm64_linux:   "b1b6f25747719c5ddaf03b61f933915574547844b6ea94e4613e81f6ab00cb1b"
    sha256 cellar: :any, x86_64_linux:  "c78a6f96439c9f0f2a8c51f2ec2e10cfe044c237a21d3caf06f71ccc893ae264"
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
                   "-L#{formula_opt_lib("aws-c-common")}", "-laws-c-common"
    system "./test"
  end
end
