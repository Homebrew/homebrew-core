class Daq < Formula
  desc "Network intrusion prevention and detection system"
  homepage "https://www.snort.org/"
  url "https://github.com/snort3/libdaq/archive/refs/tags/v3.0.27.tar.gz"
  mirror "https://fossies.org/linux/misc/libdaq-3.0.27.tar.gz"
  sha256 "03fac3da27e3230a7d26262f2480cd65a409cee3596c6758a7f9eacb7f24601c"
  license "GPL-2.0-only"
  head "https://github.com/snort3/libdaq.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d7a9c596136102d3a7cd140178b9e30fcb0ba527ba2d58d7795f971c6793a4e8"
    sha256 cellar: :any,                 arm64_sequoia: "261762fc04618a6f9e13252f58c08c1a8ebde7cc24d83d5b8fd70865696d9b89"
    sha256 cellar: :any,                 arm64_sonoma:  "d54a17fad985d4a696d1445beef32daa15a59ecf7b8e42d05057432dcaaa596a"
    sha256 cellar: :any,                 sonoma:        "1458daa5b057fd3f539cc53e95876c240564bd85a618a020f2b654437eb90f15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e790783a96e3e08b0c6529bff97f7b531c268beb95fa2ee233887374559335f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe57804cfdca5b15a86fbe37f4a2733a5c73568d5191e9ed5aa13a93b8a0d17f"
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
