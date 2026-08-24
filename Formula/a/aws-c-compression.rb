class AwsCCompression < Formula
  desc "C99 implementation of huffman encoding/decoding"
  homepage "https://github.com/awslabs/aws-c-compression"
  url "https://github.com/awslabs/aws-c-compression/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "33a91db709a547f417b1b23fdb76a64727ee8fb7ed88dd1a43be117f402db356"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c4f1e4af8a23d39df115f67f598f840e4acf9efbb4e797e46f031ff0fd668496"
    sha256 cellar: :any, arm64_sequoia: "9f2620f8f5e2eb0be6f68843172896d682b1524e5efb22f50f9afad6147f2363"
    sha256 cellar: :any, arm64_sonoma:  "3de77e3362b1c10bb1a4c4235c4c75c5a3634f0de7fd2477bcae84cff819363c"
    sha256 cellar: :any, sonoma:        "a6a9d12acb54424e1e82888df8c2a7308c31ce30944c12d0595c5751911ff8bd"
    sha256 cellar: :any, arm64_linux:   "84ba101845412dc7017689e04bec9a24e92a9b00b0c7e6c32a97076f54badbf6"
    sha256 cellar: :any, x86_64_linux:  "197ada448e2f41d407b5ec3ecebca377306a8671d9a1e79e5f3d5974e4688993"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-common"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
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
                   "-L#{formula_opt_lib("aws-c-common")}", "-laws-c-common"
    system "./test"
  end
end
