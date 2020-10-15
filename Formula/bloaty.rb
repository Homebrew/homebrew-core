class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  url "https://github.com/google/bloaty/releases/download/v1.1/bloaty-1.1.tar.bz2"
  sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"
  license "Apache-2.0"
  revision 3

  bottle do
    cellar :any
    sha256 "5d5fc675f9ca5faf03a75b9f4aaff3ef7c86a153288172a7599ade39725c3477" => :catalina
    sha256 "379ac8affe21a3dbd384c507762f5dc86262384e593c6bd8058c3f3dfe2195bf" => :mojave
    sha256 "3828160b02578c2cee7111a8bb024ae15824f8ca9e2eecc51d21c008df43ac41" => :high_sierra
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
