class Pcapplusplus < Formula
  desc "C++ network sniffing, packet parsing and crafting framework"
  homepage "https://seladb.github.io/PcapPlusPlus-Doc"
  url "https://github.com/seladb/PcapPlusPlus/archive/v19.04.tar.gz"
  sha256 "0b44074ebbaaa8666e16471311b6b99b0a5bf52d16bbe1452d26bacecfd90add"

  bottle do
    cellar :any_skip_relocation
    sha256 "a862a2c39d37c54d2dd719fc4874f8eb21f49477400f9537523c49a18c5cf7bb" => :catalina
    sha256 "66e87be04a8af4d24911300dc912481258533644dedbd1d8541368b8cf750be1" => :mojave
    sha256 "8309ef07fefb2edaf0eb7f8697a56d85faaad8f034fbb6ad5d2b526da89b3e5d" => :high_sierra
    sha256 "a856979800a5007e3f686f3d39a323bb25702457745929b34448c94df1b442b3" => :sierra
  end

  def install
    inreplace "mk/PcapPlusPlus.mk.macosx", "-I", "-I#{MacOS.sdk_path}"
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
