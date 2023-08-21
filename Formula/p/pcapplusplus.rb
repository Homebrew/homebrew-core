class Pcapplusplus < Formula
  desc "C++ network sniffing, packet parsing and crafting framework"
  homepage "https://pcapplusplus.github.io"
  url "https://github.com/seladb/PcapPlusPlus/archive/v22.11.tar.gz"
  sha256 "3172f12f2f8a8902ae1ad6be5d65c3059c42c49c1a28e97e5d8d25a48b05e44f"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f29d0fe9987fa53cfe00a2e233e7855c0b47c1949ebf15a7b0e44c214c8ecb7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "457d296b8b35c0d42ca607166b95f25ae43c17c002336888ae665540434269b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2288f40ebf6f631abe02ee620d9dabfac0657039a137e15ac51bec79d9f5c691"
    sha256 cellar: :any_skip_relocation, ventura:        "31ee737b62af96767d0244a7103897353099b6913ceca8781343c4ebb8db8597"
    sha256 cellar: :any_skip_relocation, monterey:       "4b44a71a94b22172cb00716899065d821b39883b31d5a813f956436e9ee4ef77"
    sha256 cellar: :any_skip_relocation, big_sur:        "c72dfecc6db6108832ae1e40f17169b15481f84a6a2a3dcf504715853aa19761"
    sha256 cellar: :any_skip_relocation, catalina:       "22e2908ad46b5fc172a7bc7477537b7d5f8a6a6e6992facec4513dd829c2963f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e527e2a551782daefe43ec2ba951d2ba1cadfec0d3602c9dffb2e61cc4573877"
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
