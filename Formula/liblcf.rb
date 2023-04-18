class Liblcf < Formula
  desc "Library for RPG Maker 2000/2003 games data"
  homepage "https://easyrpg.org/"
  url "https://easyrpg.org/downloads/player/0.7.0/liblcf-0.7.0.tar.xz"
  sha256 "ed76501bf973bf2f5bd7240ab32a8ae3824dce387ef7bb3db8f6c073f0bc7a6a"
  license "MIT"
  revision 3
  head "https://github.com/EasyRPG/liblcf.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "420ae4d8fd864017912ebd7863f6bead1aded6604f72f56a5a674a7cffb071c8"
    sha256 cellar: :any,                 arm64_monterey: "09dd2d9ba9b6d1a7b004051586a6a1abe6929a036a5556479840477c4e8b0b5a"
    sha256 cellar: :any,                 arm64_big_sur:  "6130ad6bf07fda73da7ba0f6b2ff98cc37122f0e3b6cd4a32c011f65db9a2499"
    sha256 cellar: :any,                 ventura:        "72a859a84917356fad5415a44dcf89274ead353c25866696c1156597edc90256"
    sha256 cellar: :any,                 monterey:       "c97668249d45a99d5da6355d8ec127db44dad2a133ca3dddf1e046035ab8d1fd"
    sha256 cellar: :any,                 big_sur:        "3e01df65a875158b6d06780db5f60286a7291201dca42c99960179b66eb25014"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66e456b887b1a3e490fedd8ead94a0f6cd95fbdcfad4df086042ec6078d7eb90"
  end

  depends_on "cmake" => :build
  depends_on "icu4c"

  uses_from_macos "expat"

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
