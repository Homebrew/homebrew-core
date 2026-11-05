class Daq < Formula
  desc "Network intrusion prevention and detection system"
  homepage "https://www.snort.org/"
  url "https://github.com/snort3/libdaq/archive/refs/tags/v3.0.29.tar.gz"
  sha256 "136deba78d195163687eb71a6dc81b725c27fde7765b7ef70eb741c371e887a8"
  license "GPL-2.0-only"
  compatibility_version 1
  head "https://github.com/snort3/libdaq.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7a89b4b16c0687a5a9be075ba323202356767735ee02a4ef6be699372a84ddcc"
    sha256 cellar: :any, arm64_tahoe:       "8721db9bd1ec3ff068a556475be3906909eb0cdacceab4fe21a9a9128c1b012e"
    sha256 cellar: :any, arm64_sequoia:     "1fc47bdc946014528761ec801507ae7a7201d166cfee5350b119bbf332a09e8e"
    sha256 cellar: :any, arm64_linux:       "d3150d2c1d289fd74b6881984a5ac80cf8482a33f000c4fe44a104d6165e1d54"
    sha256 cellar: :any, x86_64_linux:      "df08f47fd60d1ce98c54c9a58e73720fcfb3b10486771baf7c7ab06101641ede"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  uses_from_macos "libpcap"

  deny_network_access!

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
