class AwsCSdkutils < Formula
  desc "C99 library implementing AWS SDK specific utilities"
  homepage "https://github.com/awslabs/aws-c-sdkutils"
  url "https://github.com/awslabs/aws-c-sdkutils/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "673e78e9d029f31213f74eea6fb90c3750063cdec73729906e9017b0f8c95f78"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bbcdf9fe9ee17c0df6bf8b3fd0f3890d291d22f8d0ff9326e2adf92fa66ad860"
    sha256 cellar: :any, arm64_sequoia: "bb9a460abb6edf71f3494caac6525e451d6346a82c20711d834c649b224834c3"
    sha256 cellar: :any, arm64_sonoma:  "122f3cbf5d8870fd6307ba17716c3ae8325959e3433780f32fcbc8517ff5606e"
    sha256 cellar: :any, sonoma:        "1c7a9d21cdf954578a05acccc2a96b70989dc2f33954e96072e46360b621f992"
    sha256 cellar: :any, arm64_linux:   "6742b12c17f3d1364d6b40dc77923999b9fc10b5a131037849cd0841c4a15453"
    sha256 cellar: :any, x86_64_linux:  "956592a8826daee359d2057add9cd28bedc1befb1aa0e6d52642a55cced26782"
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
