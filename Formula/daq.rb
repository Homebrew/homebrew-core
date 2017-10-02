class Daq < Formula
  desc "Network intrusion prevention and detection system"
  homepage "https://www.snort.org/"
  url "https://www.snort.org/downloads/snort/daq-2.0.6.tar.gz"
  sha256 "b40e1d1273e08aaeaa86e69d4f28d535b7e53bdb3898adf539266b63137be7cb"

  bottle do
    cellar :any
    rebuild 1
    sha256 "040309732838ebc8b5ec4084e3305d26b3037a7e74a330a77590697c40f327b9" => :high_sierra
    sha256 "70f488ec88589249e94c974a688947a862a74bf7fe1198ecad5c522cecad05f9" => :sierra
    sha256 "64ec56297af8d982b5575d8bf63f00af80d3f5639d12627416fa02d9cc77a8c2" => :el_capitan
  end

  # Apple's libpcap is not recognized, because it does not have pcap_version
  depends_on "libpcap" if MacOS.version >= :sierra

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
