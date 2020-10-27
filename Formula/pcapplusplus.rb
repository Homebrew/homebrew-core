class Pcapplusplus < Formula
  desc "C++ network sniffing, packet parsing and crafting framework"
  homepage "https://pcapplusplus.github.io"
  url "https://github.com/seladb/PcapPlusPlus/archive/v20.08.tar.gz"
  sha256 "b35150a8517d3e5d5d8d1514126e4e8e4688f0941916af4256214c013c06ff50"
  license "Unlicense"

  bottle do
    cellar :any_skip_relocation
    sha256 "92055e1311b0ef55f5e65481de87e64269b7a170713575ca167649c547fd0954" => :catalina
    sha256 "25b1bf8b919fd755be9bd070265ee0f2b72de51375fc711af2de03ec4a73e046" => :mojave
    sha256 "77422853771c5a32b0d7551e5acb9db83507c8072bc39d6fa84dfab161a30643" => :high_sierra
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
