class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  url "https://github.com/google/bloaty/releases/download/v1.1/bloaty-1.1.tar.bz2"
  sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"
  license "Apache-2.0"
  revision 5

  bottle do
    cellar :any
    sha256 "923e9fbf9a2ee34f79339dbe4b012537a51cc59b05e467e813ba37519d12c881" => :big_sur
    sha256 "9fe161ff1bbdd37542285fa6e5e71b4dfecadea0e34d18c0ad48f05e0cf69e3d" => :arm64_big_sur
    sha256 "04deacbac85760d5e8966e7d548a5844aa04db5f90d8cd68001e154003aa1b1d" => :catalina
    sha256 "657f9528c53262ef42158b29eef1a285ad98662fa037b04b8d4967eb82b8cedc" => :mojave
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
