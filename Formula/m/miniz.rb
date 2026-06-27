class Miniz < Formula
  desc "Lossless, high-performance data compression library (zlib/Deflate)"
  homepage "https://github.com/richgel999/miniz"
  url "https://github.com/richgel999/miniz/archive/refs/tags/3.1.1.tar.gz"
  sha256 "8bb29c7bd6f22356e5583e794bed4a0b3e6dfcbcadb49974fc9270ccca1e5557"
  license "MIT"
  head "https://github.com/richgel999/miniz.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1791349309645e97c91130d018596feb202fb4d11a29a43354816f1245e0eb62"
    sha256 cellar: :any, arm64_sequoia: "afbe55b53018063951693652a50f2b2878721429ade040276c69262ad357e7fc"
    sha256 cellar: :any, arm64_sonoma:  "eca5fe8bef62f5be332dc6b08daceae477f8bcc9bfbf755ee4eb513de6f66067"
    sha256 cellar: :any, sonoma:        "4dffddf12309cef740dfbae0a262efe3ee6e1efbf29109f8725608917bb48e73"
    sha256 cellar: :any, arm64_linux:   "c228f31cb97c7cdf9dd2f8393bd043598211bd9a0512792f65db01aa798b5f89"
    sha256 cellar: :any, x86_64_linux:  "b53d792c91a7ccd32a153f202d9c309b7da7213a28e9804da5243038e8c54b0e"
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
