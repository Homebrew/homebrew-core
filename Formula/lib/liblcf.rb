class Liblcf < Formula
  desc "Library for RPG Maker 2000/2003 games data"
  homepage "https://easyrpg.org/"
  license "MIT"
  revision 4
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
    sha256 cellar: :any,                 arm64_sequoia: "6355bad431149665ce69b11026f48ccb0ae58505476fb0e6557fb136a11f865b"
    sha256 cellar: :any,                 arm64_sonoma:  "2a91602aa71bc7965bc685914619e140d2b76a13459d648c88deb4de928ead63"
    sha256 cellar: :any,                 arm64_ventura: "974f251736ba73d68903ad6ca9b46af831eb158b371690cfc699dffd0f209023"
    sha256 cellar: :any,                 sonoma:        "e4e8950dcb83fcbebbce42dd72e3ae62b63eacef56530c97af1d4e9347eeb7c9"
    sha256 cellar: :any,                 ventura:       "2acbd7fde87895999e6d46da68e7d3af88f0079be342a02c20490c58b34d2748"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36aa0604b238176ba7e17c14c9c29e80c6c84bf292feb443b7bb32ec02488f88"
  end

  depends_on "cmake" => :build
  depends_on "expat" # Building against `liblcf` fails with `uses_from_macos`
  depends_on "icu4c@76"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DLIBLCF_UPDATE_MIMEDB=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "lcf/lsd/reader.h"
      #include <cassert>

      int main() {
        std::time_t const current = std::time(NULL);
        assert(current == lcf::LSD_Reader::ToUnixTimestamp(lcf::LSD_Reader::ToTDateTime(current)));
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++14", "-I#{include}", "-L#{lib}", "-llcf", \
      "-o", "test"
    system "./test"
  end
end
