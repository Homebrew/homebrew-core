class AwsChecksums < Formula
  desc "Cross-Platform HW accelerated CRC32c and CRC32 with fallback"
  homepage "https://github.com/awslabs/aws-checksums"
  url "https://github.com/awslabs/aws-checksums/archive/refs/tags/v0.2.5.tar.gz"
  sha256 "c75f1697720d1f3bd5ac5e5a9613e0120337ef48c3c6bf1e6be3c802799ad8e4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "56fbe04f6cb799201cb4bb3a85bad677d430355e1968bc9344417e524765c9fe"
    sha256 cellar: :any,                 arm64_sonoma:  "fb1b2d8ebad3c864bf4ef0801973b8e5a16b3c2b5065d8e70eebe1571d6265cd"
    sha256 cellar: :any,                 arm64_ventura: "4725c088afcbd3ca2dda9185718dc3ae1abc284adbdd7ac4a9e872ebb6cea438"
    sha256 cellar: :any,                 sonoma:        "7a2fe131809186166b1324057958a302f52679080f44c6d86663dbffc8b8dd02"
    sha256 cellar: :any,                 ventura:       "e6aac87dd7612d3f9a87a6b1192593123ed8fa52f5b1bedea84d8cf195eb7894"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fceabf4bbdcd03d7e8443cc14142465bdb7546cf4b928de4319cad9a894ed9e7"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-common"

  def install
    # Intel: https://github.com/awslabs/aws-checksums/commit/e03e976974d27491740c98f9132a38ee25fb27d0
    # ARM:   https://github.com/awslabs/aws-checksums/commit/d7005974347050a97b13285eb0108dd1e59cf2c4
    ENV.runtime_cpu_detection
    # However the CPUID instruction is inside `aws-c-common` so audit fails on Intel
    # HACK: Create a dummy copy of dylib to bypass this until brew can properly handle it
    libexec.mkpath
    cp (Formula["aws-c-common"].lib/shared_library("libaws-c-common")).realpath, libexec if Hardware::CPU.intel?

    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def post_install
    # HACK: Remove dummy copy from installation as it adds 200+ KB, tripling install size
    rm_r(libexec) if libexec.exist?
  end

  test do
    (testpath/"test.c").write <<~C
      #include <aws/checksums/crc.h>
      #include <aws/common/allocator.h>
      #include <assert.h>

      int main(void) {
        struct aws_allocator *allocator = aws_default_allocator();
        const size_t len = 3 * 1024 * 1024 * 1024ULL;
        const uint8_t *many_zeroes = aws_mem_calloc(allocator, len, sizeof(uint8_t));
        uint32_t result = aws_checksums_crc32_ex(many_zeroes, len, 0);
        aws_mem_release(allocator, (void *)many_zeroes);
        assert(0x480BBE37 == result);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-laws-checksums",
                   "-L#{Formula["aws-c-common"].opt_lib}", "-laws-c-common"
    system "./test"
  end
end
