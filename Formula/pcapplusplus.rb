class Pcapplusplus < Formula
  desc "C++ network sniffing, packet parsing and crafting framework"
  homepage "https://seladb.github.io/PcapPlusPlus-Doc"
  url "https://github.com/seladb/PcapPlusPlus/archive/v18.08.tar.gz"
  sha256 "dff6f7c677b2050f880043b125e984238cd8af0f1c25864e09e87fb8d71ec9ab"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed81e6545d41b9fe6e2b5712c0ad6210a31346144912d8503ff7c06ffd91000f" => :mojave
    sha256 "2e9f6a851da52dd885e284b0393392dfbb2dec52b56517a553087fa67a608ddd" => :high_sierra
    sha256 "abdd89390998f292ed04f518471e815767285bd004165933de082d753dc44af1" => :sierra
    sha256 "bf6c8b35cc86e7acd5ddbed6ac0051a175e3329befa670fa432c6f4dc8eb6575" => :el_capitan
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
      \tg++ $(PCAPPP_LIBS_DIR) -o test test.o $(PCAPPP_LIBS)
    EOS

    system "make", "all"
    system "./test"
  end
end
