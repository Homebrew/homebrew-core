class Daq < Formula
  desc "Network intrusion prevention and detection system"
  homepage "https://www.snort.org/"
  url "https://github.com/snort3/libdaq/archive/v3.0.5.tar.gz"
  mirror "https://fossies.org/linux/misc/libdaq-3.0.5.tar.gz"
  sha256 "4281464c5502037669e69d314b628df863420f590c4999c5b567c8016cd1e658"
  license "GPL-2.0-only"
  head "https://github.com/snort3/libdaq.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0d3e31e4c3f477da99af902e3d94041e525161ecb62ebf7035a6f0849df15385"
    sha256 cellar: :any,                 arm64_big_sur:  "a381d5d506e129d22823f0993521b8f83f1bbba444d0eff6e42898830275959d"
    sha256 cellar: :any,                 monterey:       "9bfe0e35170d0e414e2b71fca7bdd39620a91d3ffc2f7a108ee3d3f7e853bb45"
    sha256 cellar: :any,                 big_sur:        "d9ce6e9dbbcdac7b64575ec19ede1197a23451fbb8c3da5aabfce2c96d14820d"
    sha256 cellar: :any,                 catalina:       "5207b98bd7d7e2954a5600409bbd862c72e1f246363f1e81359fa9a3530fba22"
    sha256 cellar: :any,                 mojave:         "4f9c630d968eef80ef96102a1f12ea0ed12f5e1c74bb1dfb484687cd8a3a2aa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15d0fd96bdd3973960ee0a6781bb7576db9b452762beb57029f7c001e096944b"
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
