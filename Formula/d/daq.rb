class Daq < Formula
  desc "Network intrusion prevention and detection system"
  homepage "https://www.snort.org/"
  url "https://github.com/snort3/libdaq/archive/refs/tags/v3.0.14.tar.gz"
  mirror "https://fossies.org/linux/misc/libdaq-3.0.14.tar.gz"
  sha256 "521364d69f8b764281ce39924d2e4c4c43348c7679768c41246adea9c7a31cc3"
  license "GPL-2.0-only"
  head "https://github.com/snort3/libdaq.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dded78da023f18d598d11a58a093c396ae5c648067535e776a1e2ea3893db1c1"
    sha256 cellar: :any,                 arm64_ventura:  "a8c96ce54dc9cf9ee3405b2472ea83877e6a591dee4ced307e8eb4c3207f2c04"
    sha256 cellar: :any,                 arm64_monterey: "8b39c9d6466d734f241d679ff4a670a480ad4a0dd691340a1d0b12132ff16168"
    sha256 cellar: :any,                 sonoma:         "64045ae24d390e5d2274964949dd1ebc9e369ee73c2d80621332b9b2913fa470"
    sha256 cellar: :any,                 ventura:        "234158e593d11578fa0f260bcb4095861ed517b7743235ca1d06779245959e91"
    sha256 cellar: :any,                 monterey:       "abd1160d1deb7818ca9d1d5a68f0209e7086c9c0ba60570da6a4efc6081b2376"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68358f500679436e80e8658c1ff5e44d2ba5dc218df12cf1a7eb3b473a673676"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  uses_from_macos "libpcap"

  def install
    system "./bootstrap"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ldaq", "-ldaq_static_pcap", "-lpcap", "-lpthread", "-o", "test"
    assert_match "[pcap] - Type: 0xb", shell_output("./test")
  end
end
