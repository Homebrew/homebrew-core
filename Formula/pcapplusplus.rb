class Pcapplusplus < Formula
  desc "C++ network sniffing, packet parsing and crafting framework"
  homepage "https://pcapplusplus.github.io"
  url "https://github.com/seladb/PcapPlusPlus/archive/v21.11.tar.gz"
  sha256 "56b8566b14b2586b8afc358e7c98268bc1dd6192197b29a3917b9df2120c51b0"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b115322fd8474bf97c2e2a74e7821965573058f6ca9d32d01b15d1741467e158"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "febbc8ea26dbdf972f6d0a00d118bb26da8c9af95ea2a4778b127bbf665571bc"
    sha256 cellar: :any_skip_relocation, monterey:       "0fc3d5d7be14ff129a449e230321a9e4b64ab3e97943486e45239d9159929888"
    sha256 cellar: :any_skip_relocation, big_sur:        "57350221b31c416d6b45284cd28e682b625510783edf9373f1f9178fcfd8f913"
    sha256 cellar: :any_skip_relocation, catalina:       "6cc2045ca6f8e554bb06a9df94884288a1cbcf66e6f480010e30894327bf0963"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38500b39456f10611f556f3dbdad46f2f546c58a4e31d9ada18f8d1a989222d4"
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
