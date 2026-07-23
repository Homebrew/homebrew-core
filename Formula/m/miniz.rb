class Miniz < Formula
  desc "Lossless, high-performance data compression library (zlib/Deflate)"
  homepage "https://github.com/richgel999/miniz"
  url "https://github.com/richgel999/miniz/archive/refs/tags/3.1.2.tar.gz"
  sha256 "98468f8924934b723276680f85238b6c78bf1f8b49b4459cc9b7214a20e2e9fb"
  license "MIT"
  head "https://github.com/richgel999/miniz.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c3b7fcfb9025975a0bff330b1920424cfa310246f567f19774a08170f4114b80"
    sha256 cellar: :any, arm64_sequoia: "2072f21aa15040df0a7153ecfdcf09b381e740523c3eb615f83433497984e3ea"
    sha256 cellar: :any, arm64_sonoma:  "64ddab612c5731f162f7f8d1d575f7603c3f8b483439c4485c1810031a974a5d"
    sha256 cellar: :any, sonoma:        "7ed348d512ebd5c8d9daa3e82583effe725cbf97d4d16de3625dc5296ccbc421"
    sha256 cellar: :any, arm64_linux:   "4d8998700dc148e0056d2ca50d118693b106a82e59cdd33c5f99ed492025d129"
    sha256 cellar: :any, x86_64_linux:  "33187bef944816294c3f174b66afa12a7c6a35c23760b2173b43a5700443ca34"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_EXAMPLES=OFF
      -DBUILD_TESTS=OFF
      -DBUILD_FUZZERS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <miniz/miniz.h>
      #include <string.h>
      #include <stdio.h>

      int main(void) {
        const char *src = "The quick brown fox jumps over the lazy dog. "
                          "The quick brown fox jumps over the lazy dog.";
        mz_ulong src_len = (mz_ulong)strlen(src);
        unsigned char compressed[256];
        unsigned char roundtrip[256];
        mz_ulong compressed_len = sizeof(compressed);
        mz_ulong roundtrip_len  = sizeof(roundtrip);

        if (mz_compress(compressed, &compressed_len,
                        (const unsigned char *)src, src_len) != MZ_OK) return 1;
        if (mz_uncompress(roundtrip, &roundtrip_len,
                          compressed, compressed_len) != MZ_OK) return 2;
        if (roundtrip_len != src_len) return 3;
        if (memcmp(roundtrip, src, src_len) != 0) return 4;

        printf("%s\\n", mz_version());
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lminiz", "-o", "test"
    assert_match(/^\d+\.\d+\.\d+/, shell_output("./test"))
  end
end
