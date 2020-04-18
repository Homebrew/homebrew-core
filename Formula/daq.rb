class Daq < Formula
  desc "Network intrusion prevention and detection system"
  homepage "https://www.snort.org/"
  url "https://www.snort.org/downloads/snort/daq-2.0.7.tar.gz"
  mirror "https://fossies.org/linux/misc/daq-2.0.7.tar.gz"
  sha256 "bdc4e5a24d1ea492c39ee213a63c55466a2e8114b6a9abed609927ae13a7705e"

  bottle do
    cellar :any
    sha256 "734f5ff5e9df559b6a807b88b6987376ed12b570fc06f59b60ff4ce71663d23e" => :catalina
    sha256 "0cc2e4509d68cc4c8b59e0e398003d7f57d50d8c85e4f4c66fc943b215da4075" => :mojave
    sha256 "d01c68e8ece0df01a1132b9591dad43a84381e601848915972fdbe9497ecada2" => :high_sierra
    sha256 "f0be58035bc6f4764567cf186673035818e6025d027695795f959fdfc88c7806" => :sierra
    sha256 "9c2720bd46954e9f2631801d8f8283974436a82827f01c9e954e319f0b9f7e88" => :el_capitan
    sha256 "02d198f42f56471feaf127824230d7ea752490b3c7f5a34f8b50ff0a85062f01" => :yosemite
    sha256 "8ce4fbbbb9f6189f6ee51d3223a81ebc7ea76069353bd284822989d6ccc364a5" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libpcap"

  # libpcap on >= 10.12 has pcap_lib_version() instead of pcap_version
  # Reported 8 Oct 2017 to bugs AT snort DOT org
  patch :p0, :DATA if MacOS.version >= :sierra

  def install
    rm_f "./configure"
    system "autoreconf", "-fiv"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    ENV.deparallelize { system "make", "install" }
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

__END__
--- ./m4/sf.m4
+++ ./m4/sf.m4
@@ -141,10 +141,9 @@
     [[
     #include <pcap.h>
     #include <string.h>
-    extern char pcap_version[];
     ]],
     [[
-        if (strcmp(pcap_version, $1) < 0)
+        if (strcmp(pcap_lib_version(), $1) < 0)
             return 1;
     ]])],
     [daq_cv_libpcap_version_1x="yes"],
