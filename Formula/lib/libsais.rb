class Libsais < Formula
  desc "Fast linear time suffix array, lcp array and bwt construction"
  homepage "https://github.com/IlyaGrebnov/libsais"
  url "https://github.com/IlyaGrebnov/libsais/archive/refs/tags/v2.10.4.tar.gz"
  sha256 "94aa88f9e29f8812214ecfa6b55f5dca14c7d8a427409c062f734a61ca4c6931"
  license "Apache-2.0"
  head "https://github.com/IlyaGrebnov/libsais.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "79b1f20b666c77eca72b9f827a036dabe7a8114e93aae6c0c8fcc635410a79c8"
    sha256 cellar: :any,                 arm64_sequoia: "63b58d789abc1dc31fcb3481c35b4f9af494711d3c82c04c6181c62df2ab0e66"
    sha256 cellar: :any,                 arm64_sonoma:  "6e04433193079ffc4d9f9054757d796e54607c4a7326a9f110b049743944b19a"
    sha256 cellar: :any,                 arm64_ventura: "c63cc2a0b039b04b0c98692130454f2225256320f2acdea2ab7225fdbcd6b009"
    sha256 cellar: :any,                 sonoma:        "af064b9655232645376cf0c0c47b58fdb2f14cd698f8ea55e541a9f521a102ba"
    sha256 cellar: :any,                 ventura:       "510f51daa4f565716ff5a1dc5deaedbc893ed3b3cbd93f432f1552be7e4f9cd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63e009572fc39dfdd39424201b784cb5b5b6728e5f21ba9ee906da515888d638"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4dc70d2f05f2cc95896bc3e28d1df5d4974df21c9bc303341e6b60d4de385a98"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DLIBSAIS_BUILD_SHARED_LIB=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libsais.h>
      #include <stdlib.h>
      int main() {
        uint8_t input[] = "homebrew";
        int32_t sa[8];
        libsais(input, sa, 8, 0, NULL);

        if (sa[0] == 4 &&
            sa[1] == 3 &&
            sa[2] == 6 &&
            sa[3] == 0 &&
            sa[4] == 2 &&
            sa[5] == 1 &&
            sa[6] == 5 &&
            sa[7] == 7) {
            return 0;
        }
        return 1;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lsais", "-o", "test"
    system "./test"
  end
end
