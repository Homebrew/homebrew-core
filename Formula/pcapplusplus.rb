class Pcapplusplus < Formula
  desc "C++ network sniffing, packet parsing and crafting framework"
  homepage "https://pcapplusplus.github.io"
  url "https://github.com/seladb/PcapPlusPlus/archive/v21.05.tar.gz"
  sha256 "f7bc2caea72544f42e3547c8acf65fca07ddd4cd45f7be2f5132dd1826ea27bb"
  license "Unlicense"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fb22355c98d5c62862816ed1ed211986cef53c1bfc3debe1eaee2a19c7249d6d"
    sha256 cellar: :any_skip_relocation, big_sur:       "a85939e3b64f246eb7b4c7d0e0c8ec7eac3a108c17b33af1328d6c54a30dfeb0"
    sha256 cellar: :any_skip_relocation, catalina:      "d0f032c98d420d3b340e5b6421877e5c89dcf31e74b2dbb6fbed33bd153ab6be"
    sha256 cellar: :any_skip_relocation, mojave:        "30ad1d79f76c841448e3e76bd25c9ddeae2c0ba543d11fbd621799f8da81077f"
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
