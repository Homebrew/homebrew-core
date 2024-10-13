class Chromaprint < Formula
  desc "Core component of the AcoustID project (Audio fingerprinting)"
  homepage "https://acoustid.org/chromaprint"
  url "https://github.com/acoustid/chromaprint/releases/download/v1.5.1/chromaprint-1.5.1.tar.gz"
  sha256 "a1aad8fa3b8b18b78d3755b3767faff9abb67242e01b478ec9a64e190f335e1c"
  license "LGPL-2.1-or-later"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "ecb32f5039c199a8f9f81329c5a09390f3c5307c3c012e10849aedadc835cf4a"
    sha256 cellar: :any,                 arm64_sonoma:   "e7f17d4e0a9d74e817a74187aafba610b424ac935ad9292df6cee1a46dc1f52f"
    sha256 cellar: :any,                 arm64_ventura:  "0230fecdaa48f58457d80c654a1ca214234ed4cc0d3cdc424aa204c3bd59741a"
    sha256 cellar: :any,                 arm64_monterey: "89c3ed17fb7d5310008a89e76328d1bc4a91216d4d9a5031ac2bd6ffaaa70afa"
    sha256 cellar: :any,                 sonoma:         "fa5ea59aa76dde0b837ae13d1bf433a54e45d109e07a61131f8da7cdcc658e33"
    sha256 cellar: :any,                 ventura:        "55a6af3551894017729941b114a1011b30c14bc524a4cd6323c42fe6fa5c8968"
    sha256 cellar: :any,                 monterey:       "d6d20851c92be78865b588a89579a87ca1dfa178c6bc845b4a741670c8acb503"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66ae2d2c38e63316a2a33ffbbdf601fd3145c2a13f5ac708180ca859613d8481"
  end

  depends_on "cmake" => :build
  depends_on "ffmpeg"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  # Backport support for FFmpeg 5+. Remove in the next release
  patch do
    url "https://github.com/acoustid/chromaprint/commit/584960fbf785f899d757ccf67222e3cf3f95a963.patch?full_index=1"
    sha256 "b9db11db3589c5f4a2999c1a782bd41f614d438f18a6ed3b5167165d0863f9c2"
  end
  patch do
    url "https://github.com/acoustid/chromaprint/commit/8ccad6937177b1b92e40ab8f4447ea27bac009a7.patch?full_index=1"
    sha256 "47c9cc257c6e5d46840e9b64ba5f1bcee2705eac3d7f5b23ca0fb4aefc6b8189"
  end
  patch do
    url "https://github.com/acoustid/chromaprint/commit/aa67c95b9e486884a6d3ee8b0c91207d8c2b0551.patch?full_index=1"
    sha256 "f90f5f13a95f1d086dbf98cd3da072d1754299987ee1734a6d62fcda2139b55d"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_TOOLS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    out = shell_output("#{bin}/fpcalc -json -format s16le -rate 44100 -channels 2 -length 10 /dev/zero")
    assert_equal "AQAAO0mUaEkSRZEGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", JSON.parse(out)["fingerprint"]
  end
end
