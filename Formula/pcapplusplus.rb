class Pcapplusplus < Formula
  desc "C++ network sniffing, packet parsing and crafting framework"
  homepage "https://pcapplusplus.github.io"
  url "https://github.com/seladb/PcapPlusPlus/archive/v21.11.tar.gz"
  sha256 "56b8566b14b2586b8afc358e7c98268bc1dd6192197b29a3917b9df2120c51b0"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77db04d2021c287793f415a059df421d0ce01d41fa90610141093f3931576e74"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebdc93c7ccb4ddb29c1fe4133657cdf9c55740927c85e1568a25a0e42debad66"
    sha256 cellar: :any_skip_relocation, monterey:       "be079d29adc3d0eef5c5e335e1e87b43eae56509abff09cd2ca2ec68800128d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "c66896b5edabf916a4db8522e38f4b836f63a2b1bb3705a21e9d9309b9fb1307"
    sha256 cellar: :any_skip_relocation, catalina:       "39ad69b47800c0d0c98f513750f1170e0dd56e0aca9e02eb29cb37e2e75c22f6"
    sha256 cellar: :any_skip_relocation, mojave:         "098062050ba28c2c168edb8abd60a6fb0f7185df57f12e5aed897b8cd98f0d9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a38e0066b0df3ee6a3ee87d0ad9dc33b57f49e65d377b7582cdb2f741bcb7229"
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
