class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "https://github.com/kimwalisch/primesieve"
  url "https://github.com/kimwalisch/primesieve/archive/refs/tags/v12.10.tar.gz"
  sha256 "0068ac9ec1cf0ca29ffb291060813608985e1921f9d702bf613343f84cb03dca"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "55916860c53b06fcaf30d88ca1b1ed6cba0d4aa01053d93928d75610ee3b9ade"
    sha256 cellar: :any,                 arm64_sequoia: "7380ba51e61e34d21b33b66d4d9f116b605d40e3b16a249cd3a78a2143ff169b"
    sha256 cellar: :any,                 arm64_sonoma:  "924ca5e81423fb6256a6f085e53ea04da51b32d44b16bc53b858cf8199ab7cb0"
    sha256 cellar: :any,                 sonoma:        "4c56fc7e7e366cd62ea667fa6150beeb48565499e695ff2212beb93232962e8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b3fbee188244cf3c4a6ceb90f093b2c5a29c4d50a22deba204f7934b791ab23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df0248a0a93ecbf18d29c0cf2636cb30da6a822f92465406671b218daa73843b"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"primesieve", "100", "--count", "--print"
  end
end
