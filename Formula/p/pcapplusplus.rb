class Pcapplusplus < Formula
  desc "C++ network sniffing, packet parsing and crafting framework"
  homepage "https://pcapplusplus.github.io"
  url "https://github.com/seladb/PcapPlusPlus/archive/refs/tags/v26.07.tar.gz"
  sha256 "58a6d7941f4e0b2484173d5429529c930e5998194e336537cf9d3a85295f8e53"
  license "Unlicense"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca63a424da114c48509c281096c3d55332408522212e913dc04aff80cc0c78d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5e89217cebfc6753a970f3826f5e263965cca19317e1ac9be10b69f70ed37d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9a3d9c988178977030dd70e67406d186143353068a745cc0962a8bebd5ced6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9114d89c7d1c85f545ddbc156a93e4570892490300a322b030f19b823d9c4cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3568319906dcd096477aa77b784ebd9d79591dd79d8812d9da15acc3aea40e36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d517a01bc603f976353a91216c286fa3bdcc68bdcc6e7c85bb1cdd9a7f6e2ca6"
  end

  depends_on "cmake" => [:build, :test]
  uses_from_macos "libpcap"

  def install
    cmake_args = %w[
      -DPCAPPP_BUILD_EXAMPLES=OFF
      -DPCAPPP_BUILD_TESTS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.12)
      project(TestPcapPlusPlus)
      set(CMAKE_CXX_STANDARD 11)

      find_package(PcapPlusPlus CONFIG REQUIRED)

      add_executable(test test.cpp)
      target_link_libraries(test PUBLIC PcapPlusPlus::Pcap++)
      set_target_properties(test PROPERTIES NO_SYSTEM_FROM_IMPORTED ON)
    CMAKE

    (testpath/"test.cpp").write <<~CPP
      #include <cstdlib>
      #include <pcapplusplus/PcapLiveDeviceList.h>
      int main() {
        const std::vector<pcpp::PcapLiveDevice*>& devList =
          pcpp::PcapLiveDeviceList::getInstance().getPcapLiveDevicesList();
        if (devList.size() > 0) {
          if (devList[0]->getName() == "")
            return 1;
          return 0;
        }
        return 0;
      }
    CPP

    system "cmake", "-S", ".", "-B", "build"
    system "cmake", "--build", "build", "--target", "test"
    system "./build/test"
  end
end
