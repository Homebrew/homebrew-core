class Libtins < Formula
  desc "C++ network packet sniffing and crafting library"
  homepage "https://libtins.github.io/"
  url "https://github.com/mfontanini/libtins/archive/v4.4.tar.gz"
  sha256 "ff0121b4ec070407e29720c801b7e1a972042300d37560a62c57abadc9635634"
  license "BSD-2-Clause"
  head "https://github.com/mfontanini/libtins.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "55e2d98465b2837a223cca0bb92e5ecc4d566c9cda05cf6f179aa017d1c36d2c"
    sha256 cellar: :any,                 arm64_big_sur:  "5fa4b31697124737566a7d7e3c61afc792a3e2a88af27a8f11d3023a76dcd7ec"
    sha256 cellar: :any,                 monterey:       "2562ccd8c4a866e5e1386882b31e9ac206558af6d10ed3f2e14c7e44d07a49b8"
    sha256 cellar: :any,                 big_sur:        "db8c030a72a519cdf99e31d6269a213852908df81f9b180d1273a17db1f9e6f8"
    sha256 cellar: :any,                 catalina:       "976fd4c5b7d38e489fefb4c481850c76b0cb3b0fc2885621c2286d7529600fa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "287989d06b4d0cc921189658011a6a5fc2735037a7d8774cb304dc47c2faf3ec"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "libpcap"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DLIBTINS_BUILD_EXAMPLES=OFF",
                    "-DLIBTINS_BUILD_TESTS=OFF",
                    "-DLIBTINS_ENABLE_CXX11=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <tins/tins.h>
      int main() {
        Tins::Sniffer sniffer("en0");
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-ltins", "-o", "test"
  end
end
