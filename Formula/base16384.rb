class Base16384 < Formula
  desc "Encode binary files to printable utf16be"
  homepage "https://github.com/fumiama/base16384"
  url "https://github.com/fumiama/base16384/archive/refs/tags/v2.2.3.tar.gz"
  sha256 "2e8f293a141608e26488bdf02b06a9a9696989e2efe42065255f61df7a03a5c6"
  license "GPL-3.0-or-later"
  head "https://github.com/fumiama/base16384.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1c9fd79db200ecf85d677ff65136a0433e031389699b91b931b4769557da8928"
    sha256 cellar: :any,                 arm64_monterey: "f2eb6e7a348ae27301f9365cb30e47de8dca0b8dac7bc455a1d86c4149945a39"
    sha256 cellar: :any,                 arm64_big_sur:  "0fbd17a6875e417b3535c1b2d3c72799a6075f77ba2833fbe2f487993b27a3c8"
    sha256 cellar: :any,                 ventura:        "d33589672b66a086e21f6d1e1d4bdc6cb3b7051a40081d649be54a0441129591"
    sha256 cellar: :any,                 monterey:       "b6067a59fdaef262330f1a6f6b656aa1afd23b4dfc24e7fb5c3f34cad34b99b3"
    sha256 cellar: :any,                 big_sur:        "8b3ce2196939ede2913b1792023f3c7042b92b0f3760838ee9c9d37406bf5267"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f16eeeada7eadd7073f84c34f4174a9751b1fd99004f6d0380bf7ee1c2f5c5d4"
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
