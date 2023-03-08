class Base16384 < Formula
  desc "Encode binary files to printable utf16be"
  homepage "https://github.com/fumiama/base16384"
  url "https://github.com/fumiama/base16384/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "948da6d9eca3af64123a7df1aa0f71a81e38ab02815ab2218e71a7aface0035e"
  license "GPL-3.0-or-later"
  head "https://github.com/fumiama/base16384.git", branch: "master"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "1234567890abcdefg",
      shell_output("echo 1234567890abcdefg | #{bin}/base16384 -e - - | #{bin}/base16384 -d - -")
  end
end
