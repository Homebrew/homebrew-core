class Pcapplusplus < Formula
  desc "C++ network sniffing, packet parsing and crafting framework"
  homepage "https://pcapplusplus.github.io"
  url "https://github.com/seladb/PcapPlusPlus/archive/v23.09.tar.gz"
  sha256 "608292f7d2a2e1b7af26adf89347597a6131547eea4e513194bc4f584a40fe74"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af49779f61c44ca769e06fc80a10b8ec9136ec1299b406b0ead6395cc6261fad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8d79ef4f65684ec323873b1084dafdc881873c9e0346f3f829a09bfd57ce4e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6519fe4b1bca812626b4707c7c55f5fd885b47a9ae9c7c3cfc6ac0844c739e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "14677a86542c1a65618edade4b114182d10ef949085802183484f19e15c6373b"
    sha256 cellar: :any_skip_relocation, ventura:        "ff4a5cacae2437fb2f4a6274cdccefa09c5260edb3b0cb4a95472c26d947389a"
    sha256 cellar: :any_skip_relocation, monterey:       "d0bcb0627b2c09e2aa453ca0dea9019289a8e61752aadbce1894372aab22df43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80a1dcc0df5d1c84671ccb419c538c008bb5a0775b5b1fbba892e2445a4e733a"
  end

  depends_on "cmake" => [:build, :test]
  uses_from_macos "libpcap"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.12)
      project(TestPcapPlusPlus)
      find_package(PcapPlusPlus CONFIG REQUIRED)

      add_executable(test test.cpp)
      target_link_libraries(test PUBLIC PcapPlusPlus::Pcap++)
      set_target_properties(test PROPERTIES NO_SYSTEM_FROM_IMPORTED ON)
    EOS

    (testpath/"test.cpp").write <<~EOS
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
    EOS

    system "cmake", "-S", ".", "-B", "build"
    system "cmake", "--build", "build", "--target", "test"
    system "./build/test"
  end
end
