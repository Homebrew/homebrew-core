class Libtins < Formula
  desc "C++ network packet sniffing and crafting library"
  homepage "https://libtins.github.io/"
  url "https://github.com/mfontanini/libtins/archive/v4.4.tar.gz"
  sha256 "ff0121b4ec070407e29720c801b7e1a972042300d37560a62c57abadc9635634"
  license "BSD-2-Clause"
  head "https://github.com/mfontanini/libtins.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "7763232c7635a53780c8551c70d3bb9bf84bd49923d938a9effc870d1a34e1f8"
    sha256 cellar: :any,                 arm64_monterey: "8a24df35212971a0ae637ad99b2ee620b2aee53f81cd54b59286ef6b8cf292c2"
    sha256 cellar: :any,                 arm64_big_sur:  "0c025e0d1f700a52261b010df05c94f225ddb812052e50307faa269c80c340c7"
    sha256 cellar: :any,                 ventura:        "69607bc339ee56c12a04eab94bfbe7893528a71401eb81b0905859dcff090409"
    sha256 cellar: :any,                 monterey:       "6633c883fcbbc4e0cc6f3fe8c9822df234d2370bd60c3e40a49a11d658311e5a"
    sha256 cellar: :any,                 big_sur:        "7ff918d08fbb7a958d05a6c236dbaa50735392c9a07ed8765779033f1eb87d19"
    sha256 cellar: :any,                 catalina:       "25d420dde9c19f24a3882213bd64766c7cccc341086ace29f699e489ef404223"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35c1e1cecccf02775bd99842818bb2f3f5f0f05deee9ec3ee6c29fe8ed26c213"
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
