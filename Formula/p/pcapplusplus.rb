class Pcapplusplus < Formula
  desc "C++ network sniffing, packet parsing and crafting framework"
  homepage "https://pcapplusplus.github.io"
  url "https://github.com/seladb/PcapPlusPlus/archive/refs/tags/v26.07.tar.gz"
  sha256 "58efbebde9df37134ca6abffdc585562155b7fc0937ced1fd6569a8c93a22ba6"
  license "Unlicense"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb27621beef3098b108098ecb75b8791145e9b7e5d7635485bf552e507ad3313"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3db414b69aba3e6fe3e8d4d46b14d50d197a0f49e7e896b7287c6761b4e0d87c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "033603f2a01e495254da5383ba6ee135be97ff00f9e2c4cc7fa2508ba9a59fdc"
    sha256 cellar: :any_skip_relocation, sonoma:        "850241bc4492ca198453957f1361efd8c60b9e46660426ffb3526f1125b40613"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a60a638a671532ec69cbc90557a85c61c375b3ef9de3fe10311159d9e48985f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d6fed04ad0ab4723d54bfb039c64434703ef377fb7e19e7ae0d463ec2c39183"
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
