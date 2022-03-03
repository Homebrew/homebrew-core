class Liblcf < Formula
  desc "Library for RPG Maker 2000/2003 games data"
  homepage "https://easyrpg.org/"
  url "https://easyrpg.org/downloads/player/0.7.0/liblcf-0.7.0.tar.xz"
  sha256 "ed76501bf973bf2f5bd7240ab32a8ae3824dce387ef7bb3db8f6c073f0bc7a6a"
  license "MIT"
  revision 1
  head "https://github.com/EasyRPG/liblcf.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "35a263d892d4bbde6669efaa33eef17676a038add327c38f230dea635e294a8e"
    sha256 cellar: :any,                 arm64_big_sur:  "2bc63c7a01e2dca4b6e701be0f696c2aff0da5e451e0ffed456a37ffd9507129"
    sha256 cellar: :any,                 monterey:       "b1824bb8df43c238e9ea5717b3cf34a4083ac4104565ede72b61313c32c05821"
    sha256 cellar: :any,                 big_sur:        "86d3d392e551484d23cbba9ada5069984f4213ca486ca4980f65375f8e03faa9"
    sha256 cellar: :any,                 catalina:       "9fb8b516f6420faf872102d14c6e6085a14f382b1aef5de71952b88650bf66ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a10abcb630c5b44108dff330404ed34b57a5af31ebda4d6a2582e391b8dce4e"
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
