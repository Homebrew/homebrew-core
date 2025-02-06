class AwsChecksums < Formula
  desc "Cross-Platform HW accelerated CRC32c and CRC32 with fallback"
  homepage "https://github.com/awslabs/aws-checksums"
  url "https://github.com/awslabs/aws-checksums/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "c688f311db8a1b70bb6d22f6e8f2817b39e1419546e339cf753d61340969eeb4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d974040bc28906c534de1bce1b3aa396458b74ea4d4fe3bf4e768ad8231a8f68"
    sha256 cellar: :any,                 arm64_sonoma:  "b5d2357241d9f1afae2b6f1bbc0314e78449a7afce8efb5dbbf380df43d5da9a"
    sha256 cellar: :any,                 arm64_ventura: "fa822ef3d73e68ceeb88f986bf8f6667bc2b7d8ef4d0587fb99591876707fb50"
    sha256 cellar: :any,                 sonoma:        "9a76710ca0ddacecf604da8424cf6417485602df17bccf40d2d0b1205c833155"
    sha256 cellar: :any,                 ventura:       "db22476178d1d4903ded1907850b5463efe4dfb931e33d02898976b4b2f56fd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ae28a4d402f2a8f336f8cd55329f6b89d5b75692c31574ca8c0977f978acc4c"
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
