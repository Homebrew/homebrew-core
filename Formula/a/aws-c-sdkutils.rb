class AwsCSdkutils < Formula
  desc "C99 library implementing AWS SDK specific utilities"
  homepage "https://github.com/awslabs/aws-c-sdkutils"
  url "https://github.com/awslabs/aws-c-sdkutils/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "75defbfd4d896b8bdc0790bd25d854218acae61b9409d1956d33832924b82045"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "87b13e606415b05e8a037200721d1182cb581e899417e6e1fc38d76846a74f23"
    sha256 cellar: :any,                 arm64_sonoma:  "0430cab23d4855b405caff327b9c1e5c5f2fee3e4f680e00372cc83aeab07751"
    sha256 cellar: :any,                 arm64_ventura: "f814da6c00d06ed124d8135bbed62ebba76f227c1aca6ffdd4a88289c18e6f35"
    sha256 cellar: :any,                 sonoma:        "93dd3dc8848c4c5a9fcaec57b3fec8e956d5e81943936bb5436959cec65acb39"
    sha256 cellar: :any,                 ventura:       "1746f08e4640b9d878ff7f292494cf09a31816fef210a4cdb269047ef1ab6d1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37ee0b7e7ec766a099fe5a49abe256da4b613aed4cd10fa2969f19f423f87412"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-common"

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_MODULE_PATH=#{Formula["aws-c-common"].opt_lib}/cmake
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
