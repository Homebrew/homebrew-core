class Base16384 < Formula
  desc "Encode binary files to printable utf16be"
  homepage "https://github.com/fumiama/base16384"
  url "https://github.com/fumiama/base16384/archive/refs/tags/v2.2.5.tar.gz"
  sha256 "63ef99367cbf113eb002f8eb9b8b47df288596055a4df117b1125ca1a4c98af8"
  license "GPL-3.0-or-later"
  head "https://github.com/fumiama/base16384.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "89a0c9ce759afd4d194adccdae2b403064787b0e3c2c3fd43cbfa93960ac24b3"
    sha256 cellar: :any,                 arm64_monterey: "fd8d94f165ed9269cc62240ec97d106b1e4d9e42278d26d78175cee54a4ff281"
    sha256 cellar: :any,                 arm64_big_sur:  "2a5e0e21b9c90a5073083165183dddd6681dc4352cd4541865d229e80305ed82"
    sha256 cellar: :any,                 ventura:        "b806b5070bc739041d0ab56f159529a158a8d112e90f9e467e1ac4c387fcc241"
    sha256 cellar: :any,                 monterey:       "4075688a6fc3f34348e8aceb479f5f358569d5eb7e467e3731317b1728a2a3b5"
    sha256 cellar: :any,                 big_sur:        "a3a59a1cf5f539683daf21679a6cd564672d3b473991c5a649e37d228b5f6b66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b83109804e8d8da746a41a9f322c0600aeb89db6832590f06abacd657b90ad7f"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    hash = pipe_output("#{bin}/base16384 -e - -", "1234567890abcdefg")
    assert_match "1234567890abcdefg", pipe_output("#{bin}/base16384 -d - -", hash)
  end
end
