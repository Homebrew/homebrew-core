class Daq < Formula
  desc "Network intrusion prevention and detection system"
  homepage "https://www.snort.org/"
  url "https://www.snort.org/downloads/snort/daq-2.0.7.tar.gz"
  mirror "https://fossies.org/linux/misc/daq-2.0.7.tar.gz"
  sha256 "bdc4e5a24d1ea492c39ee213a63c55466a2e8114b6a9abed609927ae13a7705e"

  livecheck do
    url "https://www.snort.org/downloads"
    regex(/id=["']?snort_stable_version["']?.*?href=.*?daq[._-]v?(\d+(?:\.\d+)+)\.t/im)
  end

  bottle do
    cellar :any
    sha256 "97b4ba11a541dc9720410792b363be14a190e5fbdb4f7ed473aef94f99dc0751" => :big_sur
    sha256 "3b1f25eab6e2c04f4b5e609a1d3e72c3eb55eb12d4a7acb61f43ae815bd10347" => :catalina
    sha256 "8d57a1f8536259612d6ce312b54a96e8d0fd5527000593d11765baf095d1fd2d" => :mojave
    sha256 "861fbfd197f0cef898687b427cfa259d6dbf15b2eace0036477910177b8c4c16" => :high_sierra
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
