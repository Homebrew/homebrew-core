class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  url "https://github.com/google/bloaty/releases/download/v1.1/bloaty-1.1.tar.bz2"
  sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"
  license "Apache-2.0"
  revision 5

  bottle do
    cellar :any
    sha256 "87290bf7e990ad1a82e6dd3ccd8ff2c671849818e3295b8d4154172d44f39d18" => :big_sur
    sha256 "749928462562883be2116fb4a7065c94148ad046163a39a51fce4e227e9eac30" => :catalina
    sha256 "6e277b2abe8cedf0b4b3afecc32fbcb85bc3516d7b014f1409184d1929339589" => :mojave
    sha256 "a133017f62791ec01190fc5e734e9e1e150bbcaebe65ad50491b9d2d6631a010" => :high_sierra
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
