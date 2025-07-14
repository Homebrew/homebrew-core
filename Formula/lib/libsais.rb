class Libsais < Formula
  desc "Fast linear time suffix array, lcp array and bwt construction"
  homepage "https://github.com/IlyaGrebnov/libsais"
  url "https://github.com/IlyaGrebnov/libsais/archive/refs/tags/v2.10.2.tar.gz"
  sha256 "e2fe778b69dcd9e4a1df57b8eefb577f803788336855b6a5f9fbf22683f3980e"
  license "Apache-2.0"
  head "https://github.com/IlyaGrebnov/libsais.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "24e0138a72b0551c4a633bf1b34bed2a773e603b95defd3be3fd225e7572deb1"
    sha256 cellar: :any,                 arm64_sonoma:  "b4283b63c321ef2efbcb9a3703fab30837360f54bf92219e863936d614df4459"
    sha256 cellar: :any,                 arm64_ventura: "a3e8d6f28e94395514fd9f30fc7ef7a042c8a933f4180f68c8ac573a460af39b"
    sha256 cellar: :any,                 sonoma:        "688abc5b6b6374e442e89245171e0ac4676d268ae7d7228244663922bf23fa67"
    sha256 cellar: :any,                 ventura:       "efb06331a19187eb98179aa383d205a7306a5c63a2006d5ed47b767152d1cb6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1030cbb309e1a1f54b884da2c30f583ae360c56893033af154dae63bc0701e9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99a4ec63949f7081d893f88105fb0a7816aacfc982b7478bd38240b5bb05ce75"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DLIBSAIS_BUILD_SHARED_LIB=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    lib.install shared_library("build/libsais")
    include.install "include/libsais.h"
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
