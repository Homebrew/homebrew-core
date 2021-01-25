class Pcapplusplus < Formula
  desc "C++ network sniffing, packet parsing and crafting framework"
  homepage "https://pcapplusplus.github.io"
  url "https://github.com/seladb/PcapPlusPlus/archive/v20.08.tar.gz"
  sha256 "b35150a8517d3e5d5d8d1514126e4e8e4688f0941916af4256214c013c06ff50"
  license "Unlicense"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a85939e3b64f246eb7b4c7d0e0c8ec7eac3a108c17b33af1328d6c54a30dfeb0" => :big_sur
    sha256 "fb22355c98d5c62862816ed1ed211986cef53c1bfc3debe1eaee2a19c7249d6d" => :arm64_big_sur
    sha256 "d0f032c98d420d3b340e5b6421877e5c89dcf31e74b2dbb6fbed33bd153ab6be" => :catalina
    sha256 "30ad1d79f76c841448e3e76bd25c9ddeae2c0ba543d11fbd621799f8da81077f" => :mojave
  end

  def install
    system "./configure-mac_os_x.sh", "--install-dir", prefix

    # Fix OS/X build issue in v20.08 which inclues <in.h> whether it exists or not,
    # can be removed next release:
    inreplace %w[Examples/DnsSpoofing/main.cpp
                 Examples/HttpAnalyzer/main.cpp
                 Examples/IPDefragUtil/main.cpp
                 Examples/IPFragUtil/main.cpp
                 Examples/IcmpFileTransfer/Common.cpp
                 Examples/IcmpFileTransfer/IcmpFileTransfer-catcher.cpp
                 Examples/IcmpFileTransfer/IcmpFileTransfer-pitcher.cpp
                 Examples/PcapSplitter/IPPortSplitters.h
                 Examples/SSLAnalyzer/main.cpp], "#include <in.h>", "#include <netinet/in.h>"

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
