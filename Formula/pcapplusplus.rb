class Pcapplusplus < Formula
  desc "C++ network sniffing, packet parsing and crafting framework"
  homepage "https://pcapplusplus.github.io"
  url "https://github.com/seladb/PcapPlusPlus/archive/v19.12.tar.gz"
  sha256 "9bebe2972a6678b8fb80f93b92a3caf9babae346137f2171e6941f35b56f88bb"
  license "Unlicense"

  bottle do
    cellar :any_skip_relocation
    sha256 "7b028a7ef2438fc52a831baaeaa5475282a4ac811b17464304d0a4b77d9f031b" => :catalina
    sha256 "712589c7198116011221a502c0cb158bf5b901ae06cb6a51ba7e523fb413ba48" => :mojave
    sha256 "23854dd42a6afc6abcc8056f3661309c394496292470fb15b76ab211f38b965b" => :high_sierra
  end

  def install
    system "./configure-mac_os_x.sh", "--install-dir", prefix

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
          if (devList[0]->getName() == NULL)
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
