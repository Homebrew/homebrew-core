class Daq < Formula
  desc "Network intrusion prevention and detection system"
  homepage "https://www.snort.org/"
  url "https://github.com/snort3/libdaq/archive/refs/tags/v3.0.17.tar.gz"
  mirror "https://fossies.org/linux/misc/libdaq-3.0.17.tar.gz"
  sha256 "2adfb70d07611743204db580c6603e2b16b9f5d1d32e5656f3c291995e3252a1"
  license "GPL-2.0-only"
  head "https://github.com/snort3/libdaq.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ff282bb63d1ebd08c2acb847c883851ac3487f2488abb6b8fd3482da1801655a"
    sha256 cellar: :any,                 arm64_sonoma:  "fc59e4bb69a94ad3acdb3d87854b02d5169f3502881c20b8a32ec56d58161a11"
    sha256 cellar: :any,                 arm64_ventura: "8a7f4ff2d1e3bdf0d693924afe1d836b601d14459888b4ae2d59c159bcc33487"
    sha256 cellar: :any,                 sonoma:        "09a56d487e4805fc5e297d34dcad3259ffbfce76f8a16e99b798a27270cab3a8"
    sha256 cellar: :any,                 ventura:       "eefe2f055bfabeb5c9eb019956858c2d7274405f34892280d8e5988f287b344f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0245b7f5625ff425f49493e4d40e3af288880e6ec8a6d1d872522c1f81f124ae"
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
