class Liblcf < Formula
  desc "Library for RPG Maker 2000/2003 games data"
  homepage "https://easyrpg.org/"
  url "https://easyrpg.org/downloads/player/0.8/liblcf-0.8.tar.xz"
  sha256 "6b0d8c7fefe3d66865336406f69ddf03fe59e52b5601687265a4d1e47a25c386"
  license "MIT"
  head "https://github.com/EasyRPG/liblcf.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e521ad93ddf261a38533b4bed1e2bad8e9cb81901d79054ab07953e96e9b5447"
    sha256 cellar: :any,                 arm64_monterey: "f1c4c363417c14e1554a4b6b1cee154cb58dc4bde97970c21e5fb84435fdd577"
    sha256 cellar: :any,                 arm64_big_sur:  "2ee9a94e62a483d861d4b724bc42323403cfcf36ecab078e5bf245ed9f86337d"
    sha256 cellar: :any,                 ventura:        "9329e5fe08579d41c3acfcde45761e6b42b9e10e5db60b016bc77ce02dccf746"
    sha256 cellar: :any,                 monterey:       "285c0cd9f3d83f9eef3ddfca176af79ce517fe3eed66ff4962fd60cfa604a217"
    sha256 cellar: :any,                 big_sur:        "d0e61d083c4519da85176d14e50cf2cf3c84d43b58a5e64532e87215bf7805ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0c748d14ddccfc739480e00ac57c3940f95e34b9bd5645b4cfc3e9eb011f8c3"
  end

  depends_on "cmake" => :build
  depends_on "expat" # Building against `liblcf` fails with `uses_from_macos`
  depends_on "icu4c"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DLIBLCF_UPDATE_MIMEDB=OFF",
                    *std_cmake_args
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
