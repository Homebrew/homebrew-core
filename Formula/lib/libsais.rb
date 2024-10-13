class Libsais < Formula
  desc "Fast linear time suffix array, lcp array and bwt construction"
  homepage "https://github.com/IlyaGrebnov/libsais"
  url "https://github.com/IlyaGrebnov/libsais/archive/refs/tags/v2.8.5.tar.gz"
  sha256 "c268e4ac17a2b024dba9e9ec204e694646c092fa89de767176eb7084d27780c4"
  license "Apache-2.0"
  head "https://github.com/IlyaGrebnov/libsais.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "2cb9082afc79dbe01c1a7399d53adcc8e4d96c3d977d9a5d8dc1ed991afcabb2"
    sha256 cellar: :any,                 arm64_sonoma:   "14bd3bc45e7a6d6768d36fdc06891586036f24a330f35dea65d1c275963f7f98"
    sha256 cellar: :any,                 arm64_ventura:  "3c321c5840130f77ff9afcdd68d39e5e090e5e8a0e744cf7fd1e549274b05f8f"
    sha256 cellar: :any,                 arm64_monterey: "2bcdff06dbcf58a541c77c9a1723b290bf609928746cf3dd526f04b98a5df2e6"
    sha256 cellar: :any,                 sonoma:         "05ccd2d524b6dfa5e9dfc1269a319614e781858af95051f39d3ee664bdce1eaa"
    sha256 cellar: :any,                 ventura:        "34fc7e2cf130ad0c62a45b80fde76e28de028ab6927a53660466c068f36b7ebe"
    sha256 cellar: :any,                 monterey:       "460b53902f9ee8fa5595dd24f32fe83e92c1dfdf80271b1492b63a53678e9a33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0f71ebe8be08c0b537fd304171f69dd94aa19e897ad8434ac9ef05fc8d44e8b"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DLIBSAIS_BUILD_SHARED_LIB=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    lib.install shared_library("build/liblibsais")
    lib.install_symlink shared_library("liblibsais") => shared_library("libsais")
    include.install "include/libsais.h"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lsais", "-o", "test"
    system "./test"
  end
end
