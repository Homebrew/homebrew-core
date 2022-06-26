class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  url "https://github.com/google/bloaty/releases/download/v1.1/bloaty-1.1.tar.bz2"
  sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"
  license "Apache-2.0"
  revision 8

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ba9f5939fc1a0b26f069c79e03e82c46172f3e7414cdd9a8575180535dd7ac74"
    sha256 cellar: :any,                 arm64_big_sur:  "0f3047ba12a5f2094fda29e2deb3247dfbdd4812367e27708dee4c6237688e79"
    sha256 cellar: :any,                 monterey:       "28c336018b3967d6588ff4973e579ab4fb33035a01489ea21ed2db45ef1dad68"
    sha256 cellar: :any,                 big_sur:        "f1f5844b6791049e0fed204d4e585292fdbb31b30f14399303c1649f0d5589d0"
    sha256 cellar: :any,                 catalina:       "9ba7cb7e18921902ae6539bb92087d609266913a47a380ccd8ba7e40d8a630d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "183c718270cf78df476bfd92945beebc6141ad794916c024dec0421c617304e4"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "capstone"
  depends_on "protobuf"
  depends_on "re2"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match(/100\.0%\s+(\d\.)?\d+(M|K)i\s+100\.0%\s+(\d\.)?\d+(M|K)i\s+TOTAL/,
                 shell_output("#{bin}/bloaty #{bin}/bloaty").lines.last)
  end
end
