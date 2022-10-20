class Pcapplusplus < Formula
  desc "C++ network sniffing, packet parsing and crafting framework"
  homepage "https://pcapplusplus.github.io"
  url "https://github.com/seladb/PcapPlusPlus/archive/v22.05.tar.gz"
  sha256 "5f299c4503bf5d3c29f82b8d876a19be7dea29c2aadcb52f2f3b394846c21da9"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff3ca668e89c2cc66c10d67921017931b3ceebecb67c5104ec93d6171a7ac873"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0688d833c5ffede68a0ccc000b3637279055a0c72aed10a9f4860ef605f7691f"
    sha256 cellar: :any_skip_relocation, monterey:       "ddfea2d6e61387bf8bb94903bd710c747c9f159506da7f3cba0cdd50cab5757c"
    sha256 cellar: :any_skip_relocation, big_sur:        "b61b98ef3a3c29249ffa14f74eab3b316db6122b39eb31602836e5bb74b00306"
    sha256 cellar: :any_skip_relocation, catalina:       "859bdd63e138a4c388de4b68e95aa8181635679d8758555f9118f10c62d0e216"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c05be599c504e6cfc591880bfa8bfcb50d7be89a4d2410270408c6dad0be8bde"
  end

  uses_from_macos "libpcap"

  def install
    os = OS.mac? ? "mac_os_x" : OS.kernel_name.downcase
    system "./configure-#{os}.sh", "--install-dir", prefix

    # library requires to run 'make all' and
    # 'make install' in two separate commands.
    system "make", "all"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "stdlib.h"
      #include "PcapLiveDeviceList.h"
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

    (testpath/"Makefile").write <<~EOS
      include #{etc}/PcapPlusPlus.mk
      all:
      \tg++ $(PCAPPP_BUILD_FLAGS) $(PCAPPP_INCLUDES) -c -o test.o test.cpp
      \tg++ -L#{lib} -o test test.o $(PCAPPP_LIBS)
    EOS

    system "make", "all"
    system "./test"
  end
end
