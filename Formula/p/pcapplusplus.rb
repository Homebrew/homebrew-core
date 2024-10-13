class Pcapplusplus < Formula
  desc "C++ network sniffing, packet parsing and crafting framework"
  homepage "https://pcapplusplus.github.io"
  url "https://github.com/seladb/PcapPlusPlus/archive/refs/tags/v24.09.tar.gz"
  sha256 "def261fd9c64455d5f793e1e859108f706d5a6917e7aeb31dc8828543e00bc63"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "737cecfd0d6c09d777d6ba9a9684658fa74e7318f768acf08dc6384a8f21ceb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "400feb07199fe447469d4129993ebe342c19ca9204a3a783af624ec1be6cb725"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be35fe2be342af20dfcad3a9d887b94bc502482edd44474247c2445cd344e8fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf2bdd1ece9124c2384e3595cecbaf7566a8ba91f818d1dac409574ee2f452c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "5d1199a09588adbb3cc31b539d48461894a56078973f1e692a0572a2a248bdbf"
    sha256 cellar: :any_skip_relocation, ventura:        "2b3e97132ae4c96184fe444942b91d584279b807d59b042c90f911deef9a3e10"
    sha256 cellar: :any_skip_relocation, monterey:       "e77bd094090a43874b50ea7feb955e68302e764643b95cd3a040d7b9732253a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8043eeff246207284aab2a45ee6743324bfaf03780c035e5ae49842a3ab3307"
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
      set(CMAKE_CXX_STANDARD 11)

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
