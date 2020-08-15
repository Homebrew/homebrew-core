class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  url "https://github.com/google/bloaty/releases/download/v1.1/bloaty-1.1.tar.bz2"
  sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"
  license "Apache-2.0"
  revision 2

  bottle do
    cellar :any
    sha256 "94aa3561343dc487bc3c6ac1d08c7d8fada44d9309236153b3140030aa63ccf4" => :catalina
    sha256 "85dd26047db38e0fe9bbe2ce6eda78f757fe699df9b737d8b1f90a185533f19c" => :mojave
    sha256 "ec2cfde251cf64f4c132c108a45df0859d68a19963dccbd12c24306e23a1a330" => :high_sierra
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
