class Daq < Formula
  desc "Network intrusion prevention and detection system"
  homepage "https://www.snort.org/"
  url "https://github.com/snort3/libdaq/archive/refs/tags/v3.0.18.tar.gz"
  mirror "https://fossies.org/linux/misc/libdaq-3.0.18.tar.gz"
  sha256 "301db00d33ccd7be546ffb40cd9f4fc41031a5d67196b48bd8b76ae36e10f078"
  license "GPL-2.0-only"
  head "https://github.com/snort3/libdaq.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "203059c4390dbf47222f967da593a46fd7b65714dfd1ab7b55c1b804b9f69939"
    sha256 cellar: :any,                 arm64_sonoma:  "c06f5b8975806be9f8125a4fd6bed0d7bae16fca467faefb8fa36e55e37d39a2"
    sha256 cellar: :any,                 arm64_ventura: "2df06832261bb93693a9ae56c7e5c56bf135951a1f66094c14a10ff8da01491b"
    sha256 cellar: :any,                 sonoma:        "ace25267b03f1dc835fe63b6226d81762c7798c738e056895a071a7335bc37d0"
    sha256 cellar: :any,                 ventura:       "112f058f184698fdef0bddb9a5a1c761f2d0e3c5ae4052007f6918e44f0b9549"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62e607192ee0bdab140fec82d992728d1edc7345df53ebd5c59a8c0a7ea476e6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  uses_from_macos "libpcap"

  def install
    system "./bootstrap"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <stdio.h>
      #include <daq.h>
      #include <daq_module_api.h>

      extern const DAQ_ModuleAPI_t pcap_daq_module_data;
      static DAQ_Module_h static_modules[] = { &pcap_daq_module_data, NULL };

      int main()
      {
        int rval = daq_load_static_modules(static_modules);
        assert(rval == 1);
        DAQ_Module_h module = daq_modules_first();
        assert(module != NULL);
        printf("[%s] - Type: 0x%x", daq_module_get_name(module), daq_module_get_type(module));
        module = daq_modules_next();
        assert(module == NULL);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-ldaq", "-ldaq_static_pcap", "-lpcap", "-lpthread", "-o", "test"
    assert_match "[pcap] - Type: 0xb", shell_output("./test")
  end
end
