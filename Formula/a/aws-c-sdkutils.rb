class AwsCSdkutils < Formula
  desc "C99 library implementing AWS SDK specific utilities"
  homepage "https://github.com/awslabs/aws-c-sdkutils"
  url "https://github.com/awslabs/aws-c-sdkutils/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "ddf9d09ba137ad0697afe1c09f5d778d6b2f1aadb277dffd231ff615ae34bc82"
  license "Apache-2.0"
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1f3a86876f95666e59eade86e9457c5a222cafcacd946a1d46f33d12c24beec7"
    sha256 cellar: :any, arm64_tahoe:       "d8c8dd2adee020199b6e165b41eb5b5e15ce98eedf402aed6f33878b4a8fced7"
    sha256 cellar: :any, arm64_sequoia:     "03bf903dcfb4c442dfa6d4c6d33fe6f65198ab0397d88386a70fdbdb5bbbc3e2"
    sha256 cellar: :any, arm64_sonoma:      "4c1fac854ae9970781e1ec73c963e8ad0255dd8999283f8a262706aceed2da3c"
    sha256 cellar: :any, arm64_linux:       "a8cfc7f6908f0a4e8c697205b417bed5862608f96ef7dd1e8f2a28d96c24c655"
    sha256 cellar: :any, x86_64_linux:      "0cc97e4c629fcfde41f8dcf3112cd18e41c2114717ed30dafb3bde5cb8ae3f9b"
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
