class Liblcf < Formula
  desc "Library for RPG Maker 2000/2003 games data"
  homepage "https://easyrpg.org/"
  url "https://easyrpg.org/downloads/player/0.7.0/liblcf-0.7.0.tar.xz"
  sha256 "ed76501bf973bf2f5bd7240ab32a8ae3824dce387ef7bb3db8f6c073f0bc7a6a"
  license "MIT"
  revision 2
  head "https://github.com/EasyRPG/liblcf.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a2b5fc7ec2b96d5c2605404d7843664873ce443f9a8570982ee2abe7acc3c7fd"
    sha256 cellar: :any,                 arm64_monterey: "68e94e4f58730ea5e6c9feeeea014c1bb698473749280327cc2aafa402e46cd1"
    sha256 cellar: :any,                 arm64_big_sur:  "c53896d6203b499b21cfe49e23b8f9c8b8e9821f6fa15507e612ef4cc1d9be39"
    sha256 cellar: :any,                 ventura:        "0ad367fac0a53f72379fe4df08907f13ab619fdd671a2e78bc7fecb6204545f8"
    sha256 cellar: :any,                 monterey:       "78dc57cba649af4c239fdb76883bb01e810511072cfaec1724d9ad5548392749"
    sha256 cellar: :any,                 big_sur:        "f4e5fcf1451d07aa37cf64b068a76b2b7eb6c0c7eb4cfc67f76cd906a82494ac"
    sha256 cellar: :any,                 catalina:       "dbaa6069c2a9b1e2991e718e02c54fcf47ac369db007030b1f5123028beb4e52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40f199d20953a9bb89a29829807573fe4ebcdd3ff6b3bc22b90ed8fce2cf26cb"
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
