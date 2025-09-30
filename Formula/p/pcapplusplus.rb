class Pcapplusplus < Formula
  desc "C++ network sniffing, packet parsing and crafting framework"
  homepage "https://pcapplusplus.github.io"
  url "https://github.com/seladb/PcapPlusPlus/archive/refs/tags/v25.05.tar.gz"
  sha256 "66c11d61f3c8019eaf74171ad10229dfaeab27eb86859c897fb0ba1298f80c94"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "badacc3ee645e30f563ebd4c127a993b0ecb64beb34d2663965e7e57daae345c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0fa7a89759395ca21657a2f4ad0cd1ce38956a9bdef1000feffa86dfd4f3a2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e0d980ded05983801b97aa6f7737f7c4bf91252fb2e146ed552514d5b5b8547"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eb59ce27fdc30a559228ff984d4a2f51a2ea86c693a575736537296175ec2244"
    sha256 cellar: :any_skip_relocation, sonoma:        "9019452d1e6616946480223d5725df1f1ea43c3bdb5652c0c387b10a8239d2c4"
    sha256 cellar: :any_skip_relocation, ventura:       "f6a57b0410bd1a733ee3b342addf244cda48557be7f226b46c3dfb4d1ed2df7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e09fd13802dd4b8149f58fb69cfaf46dab0faeff6b0db6381809ee03fb9188bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42c2a06a698bfd44bef147d045900a270af1418a3d2828d0ff406f1eeb0c02af"
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
