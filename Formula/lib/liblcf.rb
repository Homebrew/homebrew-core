class Liblcf < Formula
  desc "Library for RPG Maker 2000/2003 games data"
  homepage "https://easyrpg.org/"
  license "MIT"
  revision 3
  head "https://github.com/EasyRPG/liblcf.git", branch: "master"

  stable do
    url "https://easyrpg.org/downloads/player/0.8/liblcf-0.8.tar.xz"
    sha256 "6b0d8c7fefe3d66865336406f69ddf03fe59e52b5601687265a4d1e47a25c386"

    # Backport C++17 for `icu4c` 75. Remove in the next release.
    patch do
      url "https://github.com/EasyRPG/liblcf/commit/8c782e54ba244981141d91e7d44922952563677c.patch?full_index=1"
      sha256 "593f729e7f9a5411e6d8548aaac0039e09eee437f525409a9ca8513a0ee15cd0"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d1d9e646c81b640cbaf17ad905eebeb66d6dac978a888cb1fafeca5a78611179"
    sha256 cellar: :any,                 arm64_sonoma:  "256529d43242a8972f90f8bb52b9615ee958ed6f87e61a9a40f70c135ece3a4a"
    sha256 cellar: :any,                 arm64_ventura: "04509b3dff6ce0ec1858f8ba1b2baa3361aa4aa5e74b8ca9384508f26f76a574"
    sha256 cellar: :any,                 sonoma:        "857e6875f3089228ddde5f8ece70abef84e6e065355d4d10f5398aca2888ffa9"
    sha256 cellar: :any,                 ventura:       "dc5f05d256ad44a4f20f434a78b98ddba9d88f65ff31670c336dbc5acd0ee3f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e16c8a8486531339e8df25b6cc14de1165f922e83d2458faf2716376d489b10e"
  end

  depends_on "cmake" => :build
  depends_on "expat" # Building against `liblcf` fails with `uses_from_macos`
  depends_on "icu4c@75"

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
