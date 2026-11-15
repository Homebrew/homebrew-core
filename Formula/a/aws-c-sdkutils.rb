class AwsCSdkutils < Formula
  desc "C99 library implementing AWS SDK specific utilities"
  homepage "https://github.com/awslabs/aws-c-sdkutils"
  url "https://github.com/awslabs/aws-c-sdkutils/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "c74ce4e19304051d961255fdeb3cd431cfc81896c608a22f94c2321b5a19d6ba"
  license "Apache-2.0"
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5756276d411ed024984ee7bb45e373d7b4824704eced8b16f06d3108090a0532"
    sha256 cellar: :any, arm64_tahoe:       "ea064e55171cfa96038657274b54d2794a771939039645817fd514793a0d313e"
    sha256 cellar: :any, arm64_sequoia:     "8a2edf42ddfe0402d5c7fc9f905b0bf322c8702f8646746b4d9aaafbac3da1b0"
    sha256 cellar: :any, arm64_linux:       "ca20b692fe49a7e38049d6e6a20e571f88e6ae158ec8274358b49ae91110908f"
    sha256 cellar: :any, x86_64_linux:      "2837b0147c9f6f70f2927e721163f8bee7103396eeb95b8587431f7874981f0f"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-common"

  deny_network_access!

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
