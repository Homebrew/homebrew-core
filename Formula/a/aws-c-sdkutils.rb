class AwsCSdkutils < Formula
  desc "C99 library implementing AWS SDK specific utilities"
  homepage "https://github.com/awslabs/aws-c-sdkutils"
  url "https://github.com/awslabs/aws-c-sdkutils/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "802b8c4169da2b4cf5c48f9598fb778faccd3e052e443a482089193411c2b7bb"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b8de22f9191b5cb337b016a9799788f02a49bdb5674b2c75c28eed4c53724d7c"
    sha256 cellar: :any, arm64_sequoia: "b49d223d375e245888e64bc45bb6b53c6da9fb28f8eace4f920b7fbf02780ef1"
    sha256 cellar: :any, arm64_sonoma:  "61d1fd7dc9129ac4b1091ec0f35647e4075e766b6dc9d1dd201dd8836b43ab64"
    sha256 cellar: :any, sonoma:        "fd32c66252a0bbde704be62401f03db220fd85d07dfb5d26c47b2671562cb918"
    sha256 cellar: :any, arm64_linux:   "a6e0f5f6a07d58839436ffb7501b80ea5c4fc120b6a9e2361a81d98b85fab4ea"
    sha256 cellar: :any, x86_64_linux:  "e231ed2322593c23fa817bf75f05b2e4a202bbc60ce87c578446254f906db44a"
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
