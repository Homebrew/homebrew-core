class Daq < Formula
  desc "Network intrusion prevention and detection system"
  homepage "https://www.snort.org/"
  url "https://github.com/snort3/libdaq/archive/v3.0.4.tar.gz"
  mirror "https://fossies.org/linux/misc/libdaq-3.0.4.tar.gz"
  sha256 "a376c7625d1442ddb7e3c75954c910cc9d64440e2f8f345981aa5fa6999ea206"
  license "GPL-2.0-only"
  head "https://github.com/snort3/libdaq.git"

  bottle do
    sha256 cellar: :any, big_sur:     "97b4ba11a541dc9720410792b363be14a190e5fbdb4f7ed473aef94f99dc0751"
    sha256 cellar: :any, catalina:    "3b1f25eab6e2c04f4b5e609a1d3e72c3eb55eb12d4a7acb61f43ae815bd10347"
    sha256 cellar: :any, mojave:      "8d57a1f8536259612d6ce312b54a96e8d0fd5527000593d11765baf095d1fd2d"
    sha256 cellar: :any, high_sierra: "861fbfd197f0cef898687b427cfa259d6dbf15b2eace0036477910177b8c4c16"
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
