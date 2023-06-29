class Liblcf < Formula
  desc "Library for RPG Maker 2000/2003 games data"
  homepage "https://easyrpg.org/"
  url "https://easyrpg.org/downloads/player/0.8/liblcf-0.8.tar.xz"
  sha256 "6b0d8c7fefe3d66865336406f69ddf03fe59e52b5601687265a4d1e47a25c386"
  license "MIT"
  revision 1
  head "https://github.com/EasyRPG/liblcf.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "06aff4bc7c277c9c98b2901a720a49673ad5c7d9be52a3920cb657388edb9335"
    sha256 cellar: :any,                 arm64_monterey: "151d6daeb6f60ad56cf37569269498bda0c4d14874ce9e04d06ca5dc14dad46f"
    sha256 cellar: :any,                 arm64_big_sur:  "37b4ca74a5ddd4f08651005cc9a74bf79cc22501df866be6016ffc00e3c01a25"
    sha256 cellar: :any,                 ventura:        "31a39c74c9522f9033cc00d33a3858ef46df167b9c72c4f2a19aa04c1681cc9b"
    sha256 cellar: :any,                 monterey:       "766c6ca63a83b08a67d1d45223effa736b6725fc118dac65db9e9ec9d5aff0a8"
    sha256 cellar: :any,                 big_sur:        "1289ad51f7274e2a58d004ee702a59a80cfff8313483eb89607292353e41e51c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47297a9348edb42e46b7b990d5531423004c168d628fb5a1fae6ae7fd6bfc9fd"
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
