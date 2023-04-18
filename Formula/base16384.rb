class Base16384 < Formula
  desc "Encode binary files to printable utf16be"
  homepage "https://github.com/fumiama/base16384"
  url "https://github.com/fumiama/base16384/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "948da6d9eca3af64123a7df1aa0f71a81e38ab02815ab2218e71a7aface0035e"
  license "GPL-3.0-or-later"
  head "https://github.com/fumiama/base16384.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7fea8c0e03eb1969ba4ca63b0a0db3db9488b0aa9b2804ab88688a454457f060"
    sha256 cellar: :any,                 arm64_monterey: "60ed6835a594b7846a88528ccf089d027a208c226598bfa80bbb494c17cfcfbf"
    sha256 cellar: :any,                 arm64_big_sur:  "c67638aac008f6ae6177b05d4d148f72059ff3759243bc76678e7e4b76d4590f"
    sha256 cellar: :any,                 ventura:        "88f7c8b07474876f0e3e20fcef604ed5183be08e90f694c7ee7dae21aec78753"
    sha256 cellar: :any,                 monterey:       "8c62fa52e28dcdad82d4d27a97128a8ec17839cf0b1420057a8b5916bfdd7c4d"
    sha256 cellar: :any,                 big_sur:        "88a9a07d80b4d80d984a89294e62e57793cc2d1b74f0675753ff893b91f562a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c728306f2bac2d06bcbe4705ed4206a92ed86f87341d08b0e8db4b60ad46985f"
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
