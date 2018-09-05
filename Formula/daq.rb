class Daq < Formula
  desc "Network intrusion prevention and detection system"
  homepage "https://www.snort.org/"
  url "https://www.mirrorservice.org/sites/distfiles.macports.org/daq/daq-2.0.6.tar.gz"
  mirror "https://fossies.org/linux/misc/daq-2.0.6.tar.gz"
  sha256 "b40e1d1273e08aaeaa86e69d4f28d535b7e53bdb3898adf539266b63137be7cb"

  bottle do
    cellar :any
    sha256 "0cc2e4509d68cc4c8b59e0e398003d7f57d50d8c85e4f4c66fc943b215da4075" => :mojave
    sha256 "d01c68e8ece0df01a1132b9591dad43a84381e601848915972fdbe9497ecada2" => :high_sierra
    sha256 "f0be58035bc6f4764567cf186673035818e6025d027695795f959fdfc88c7806" => :sierra
    sha256 "9c2720bd46954e9f2631801d8f8283974436a82827f01c9e954e319f0b9f7e88" => :el_capitan
    sha256 "02d198f42f56471feaf127824230d7ea752490b3c7f5a34f8b50ff0a85062f01" => :yosemite
    sha256 "8ce4fbbbb9f6189f6ee51d3223a81ebc7ea76069353bd284822989d6ccc364a5" => :mavericks
    sha256 "bced15005e13eaa11ec6d47afbb1137f61231a191fb05a295e2762cc6cc8ef29" => :mountain_lion
  end

  # libpcap on >= 10.12 has pcap_lib_version() instead of pcap_version
  # Reported 8 Oct 2017 to bugs AT snort DOT org
  if MacOS.version >= :sierra
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/b345dac/daq/patch-pcap-version.diff"
      sha256 "20d2bf6aec29824e2b7550f32251251cdc9d7aac3a0861e81a68cd0d1e513bf3"
    end
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <daq.h>
      #include <stdio.h>

      int main()
      {
        DAQ_Module_Info_t* list;
        int size = daq_get_module_list(&list);
        daq_free_module_list(list, size);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ldaq", "-o", "test"
    system "./test"
  end
end
