class Base16384 < Formula
  desc "Encode binary files to printable utf16be"
  homepage "https://github.com/fumiama/base16384"
  url "https://github.com/fumiama/base16384/archive/refs/tags/v2.2.4.tar.gz"
  sha256 "5701519bd07a58019bc5204ca93194026f2869969cb8bc2563cbcb450f2e80bf"
  license "GPL-3.0-or-later"
  head "https://github.com/fumiama/base16384.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "15ac197ab48cfe0a71c9e2ac260a948b7bb195ec5f2d1abfc255045c9139749f"
    sha256 cellar: :any,                 arm64_monterey: "272473b802a6e7bf7172a88bc449c663962c19811a08c097c39f7c2763ffeccb"
    sha256 cellar: :any,                 arm64_big_sur:  "12e61ac49955df673d3616729b6eb9b89a4811c51c9ca3490f02966d379134ce"
    sha256 cellar: :any,                 ventura:        "b007d8064d553eb944d3621e725da824a113007b142e4529e61a08578db100af"
    sha256 cellar: :any,                 monterey:       "df1b2195ab4b00ab2809b2328db46c7facff530523c9fda84547ec9476f362f0"
    sha256 cellar: :any,                 big_sur:        "63d289c9883b7bb655c9d908d3b8ae14787f6622ba19b89bef9327dd2c86006e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c37eb2bbb91d977f07549cfc609c528b093fbd9c2079ecd2c15d48c0880b2e1"
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
