class Liblcf < Formula
  desc "Library for RPG Maker 2000/2003 games data"
  homepage "https://easyrpg.org/"
  url "https://easyrpg.org/downloads/player/0.7.0/liblcf-0.7.0.tar.xz"
  sha256 "ed76501bf973bf2f5bd7240ab32a8ae3824dce387ef7bb3db8f6c073f0bc7a6a"
  license "MIT"
  head "https://github.com/EasyRPG/liblcf.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7f1164e942934fc234d035cfc9eab11330831244bc69a96061fb3cefc00dd03b"
    sha256 cellar: :any,                 arm64_big_sur:  "be2a943fe7db52a0a29c910e04f981464a58e0cab77b65b3f0c39fd56490635b"
    sha256 cellar: :any,                 monterey:       "5520823380b4ff8f68aeaacef327c264e6edd9208e30acd717d792d527aa3763"
    sha256 cellar: :any,                 big_sur:        "7ef6b01e609ba9d7f4d57d28b97e396122b6f09245954a6229493d86ea3aa879"
    sha256 cellar: :any,                 catalina:       "f73afcd81ca34da7633475f9ee5cb470b12fd5e485199bc5073d6d30dacbb77f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b640ca618fe564b9377ebdb7d7f3b7adcdcbef7690ae2e4a37b473d21c0e255a"
  end

  depends_on "cmake" => :build
  depends_on "icu4c"

  uses_from_macos "expat"

  def install
    args = std_cmake_args + ["-DLIBLCF_UPDATE_MIMEDB=OFF"]
    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "lcf/lsd/reader.h"
      #include <cassert>

      int main() {
        std::time_t const current = std::time(NULL);
        assert(current == lcf::LSD_Reader::ToUnixTimestamp(lcf::LSD_Reader::ToTDateTime(current)));
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++14", "-I#{include}", "-L#{lib}", "-llcf", \
      "-o", "test"
    system "./test"
  end
end
