class AwsCCompression < Formula
  desc "C99 implementation of huffman encoding/decoding"
  homepage "https://github.com/awslabs/aws-c-compression"
  url "https://github.com/awslabs/aws-c-compression/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "7e5d7308d1dbb1801eae9356ef65558f707edf33660dd6443c985db9474725eb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c632ff3b5ca3ca5ad5d18d2ea67694c5d56b79001b896aca15125092ca145e3c"
    sha256 cellar: :any,                 arm64_sonoma:  "69a5b1c9ca168185b7094a8dfcc3a827fb97109ecf457027a407c79776f89cba"
    sha256 cellar: :any,                 arm64_ventura: "2f34ad9665411033f41729cbddd83bb619c60c2162c76cee79264ecf5481523d"
    sha256 cellar: :any,                 sonoma:        "c5d32b96e1c8a44eac804bb2cba6398d552068e4706dc8fc6a72d542f6d19845"
    sha256 cellar: :any,                 ventura:       "809a35d629a365e728c24517eaac912141f3c3d9aaed347b25dffcacc91b536c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64ef3162e3d5f2d31e9ef0b19b19b3b2049b937cf725c10d5be456a71c3bd74e"
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
    (testpath/"test.c").write <<~C
      #include <aws/compression/compression.h>
      #include <aws/common/allocator.h>
      #include <assert.h>
      #include <string.h>

      int main(void) {
        struct aws_allocator *allocator = aws_default_allocator();
        aws_compression_library_init(allocator);

        const char *err_name = aws_error_name(AWS_ERROR_COMPRESSION_UNKNOWN_SYMBOL);
        const char *expected = "AWS_ERROR_COMPRESSION_UNKNOWN_SYMBOL";
        assert(strlen(expected) == strlen(err_name));
        for (size_t i = 0; i < strlen(expected); ++i) {
          assert(expected[i] == err_name[i]);
        }

        aws_compression_library_clean_up();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-laws-c-compression",
                   "-L#{Formula["aws-c-common"].opt_lib}", "-laws-c-common"
    system "./test"
  end
end
