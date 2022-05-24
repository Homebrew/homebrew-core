class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "https://github.com/kimwalisch/primesieve"
  url "https://github.com/kimwalisch/primesieve/archive/v7.9.tar.gz"
  sha256 "c567f2a1a9d46a70020f920eb2c794142528a31a055995500e7fcb19642b7c91"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "57fc366a7181ba08bd207201db2fcd9eef2fbd98868784858b05a1792492bc1a"
    sha256 cellar: :any,                 arm64_big_sur:  "a9e300fdd0cf22dcde84756d36b9f26bbf2270af54c17d9ae7262d45ee7c9140"
    sha256 cellar: :any,                 monterey:       "0bc83cd153427205551f14ebec8d99abd94775ab254d63218ddfa79e693cfe16"
    sha256 cellar: :any,                 big_sur:        "bb7bb64290b044eeb7b465331d24abe30391038f86fa33995edb63c7b5299250"
    sha256 cellar: :any,                 catalina:       "f15f95934637e727e52a3c27c22e95a1cebd8693d36bed1cdc584a8a58bfc417"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "947534128f895147f25b14ac337b009e9f660da067b6020ded41c065771f0f3c"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/primesieve", "100", "--count", "--print"
  end
end
