class Libsais < Formula
  desc "Fast linear time suffix array, lcp array and bwt construction"
  homepage "https://github.com/IlyaGrebnov/libsais"
  url "https://github.com/IlyaGrebnov/libsais/archive/refs/tags/v2.12.2.tar.gz"
  sha256 "9a3ab90beb94ef4d9cf633f39f3d45fe355401dcffcda067a4e330895afc20d7"
  license "Apache-2.0"
  head "https://github.com/IlyaGrebnov/libsais.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "880daf7bc6a7f03adfaf6f49a0cf391cabac103be308db8f0c12b4ec4e869940"
    sha256 cellar: :any, arm64_tahoe:       "05b05573fdabd0c7b2ed680b142a4e644dd0c7684ee43ffe7db176ef80653192"
    sha256 cellar: :any, arm64_sequoia:     "d28c1cf9505515b0e0ecab6bdf4dc913b3b4eb8bd1fcbac5d3dee20c803c4ba1"
    sha256 cellar: :any, arm64_linux:       "d80dccac8ff9d8253d75a9e534a37e08d6959dd1765cd151fb7968bf5b0b2478"
    sha256 cellar: :any, x86_64_linux:      "ba79b5080d30c062557384d6a54cf2f71d54d6d68875a06a6241df3c4b3d675e"
  end

  depends_on "cmake" => :build

  deny_network_access!

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
