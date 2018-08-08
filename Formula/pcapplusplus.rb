class Pcapplusplus < Formula
  desc "Multiplatform C++ network sniffing and packet parsing and crafting"
  homepage "https://seladb.github.io/PcapPlusPlus-Doc"
  url "https://github.com/seladb/PcapPlusPlus/archive/v18.08.tar.gz"
  sha256 "dff6f7c677b2050f880043b125e984238cd8af0f1c25864e09e87fb8d71ec9ab"

  def install
    system "./configure-mac_os_x.sh", "--install-dir", prefix

    # library requires to run 'make all' and 'make install' in two separate commands
    system "make", "all"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "stdlib.h"
      #include "PcapLiveDeviceList.h"
      int main() {
        pcpp::PcapLiveDevice* dev = pcpp::PcapLiveDeviceList::getInstance().getPcapLiveDeviceByName("en0");
        if (dev == NULL)
          exit(1);
        exit(0);
      }
    EOS

    (testpath/"Makefile").write <<~EOS
      include #{etc}/PcapPlusPlus.mk
      all:
      \tg++ $(PCAPPP_BUILD_FLAGS) $(PCAPPP_INCLUDES) -c -o test.o test.cpp
      \tg++ $(PCAPPP_LIBS_DIR) -o test test.o $(PCAPPP_LIBS)
    EOS

    system "make", "all"
  end
end
