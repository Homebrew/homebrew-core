class AwsCSdkutils < Formula
  desc "C99 library implementing AWS SDK specific utilities"
  homepage "https://github.com/awslabs/aws-c-sdkutils"
  url "https://github.com/awslabs/aws-c-sdkutils/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "493cbed4fa57e0d4622fcff044e11305eb4fc12445f32c8861025597939175fc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d0f34c54b3e8be0bbff43be46378156e8b5177f90091499dbd51c27969e1de2a"
    sha256 cellar: :any,                 arm64_sequoia: "507738d55485b9455c59f6bff4a7280445483dce69963ac052190135bc53bccf"
    sha256 cellar: :any,                 arm64_sonoma:  "a5583794b7a383d70c8a3814609660b0a886482b10e520c7bbfa403b4d7a6c98"
    sha256 cellar: :any,                 arm64_ventura: "24a84103b826055429f427388ab4c3591724cc5acc68ff9fb1118f9ee81935ce"
    sha256 cellar: :any,                 sonoma:        "6159606530f7ed2acd4b495413389c2efc43cc65a7cbb7b86dfcecfd5cf677cb"
    sha256 cellar: :any,                 ventura:       "15f6671877aa6cb73bcfc14c91b040265c5e57cbc29b523cfec3457bc9e5aeaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50513535d8578d5536701e223d3b31f0ded0977a1d1350ce96b70913f556515f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "775f9fce83bb072b3a9d381a496bded25d40fba78a1d6a609888e58e573d3fbe"
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
