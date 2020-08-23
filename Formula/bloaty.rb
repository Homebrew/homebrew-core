class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  url "https://github.com/google/bloaty/releases/download/v1.1/bloaty-1.1.tar.bz2"
  sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"
  license "Apache-2.0"
  revision 2

  bottle do
    cellar :any
    sha256 "9c0aad71da35c2719b1e2056ed2b3667b717b5c4f65df0b6e9b91cce5ccab7cd" => :catalina
    sha256 "6454e2c689e71e2afaa692f14a71c07820e8d99c193a1da4b58b7e504a810a83" => :mojave
    sha256 "1fe1f86ebf763e5388eb7191d0790b3f5a0a23afd08d4dd2b01bc4b43dee8fe4" => :high_sierra
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
    assert_match /100\.0%\s+(\d\.)?\d+(M|K)i\s+100\.0%\s+(\d\.)?\d+(M|K)i\s+TOTAL/,
                 shell_output("#{bin}/bloaty #{bin}/bloaty").lines.last
  end
end
