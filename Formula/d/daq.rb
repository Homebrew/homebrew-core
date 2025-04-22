class Daq < Formula
  desc "Network intrusion prevention and detection system"
  homepage "https://www.snort.org/"
  url "https://github.com/snort3/libdaq/archive/refs/tags/v3.0.19.tar.gz"
  mirror "https://fossies.org/linux/misc/libdaq-3.0.19.tar.gz"
  sha256 "28d026de46f8206b1a74dd6bf7de10ca19d7a7c95a463744b9f79e51958e5889"
  license "GPL-2.0-only"
  head "https://github.com/snort3/libdaq.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "de5fecd1ca4361de4a8435280165af94aab2dc93ef0e5596a1bf7ad5e52213ed"
    sha256 cellar: :any,                 arm64_sonoma:  "95684f5dbb32aee8326a248018e22ccf2457e1d0d8c6513bf5886663588987e4"
    sha256 cellar: :any,                 arm64_ventura: "c698259bece3eeaca5400f4834b6868f182545137c31ef3b55320ab72b7c3ec6"
    sha256 cellar: :any,                 sonoma:        "97f451492598266dd1802c7ef01306793f3093e1199c432714240831956c0dc1"
    sha256 cellar: :any,                 ventura:       "e36b53523a795b1b2d1b6c706760ca98021982e001c29efe44aecc67008f4f83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ceaab9f251d411b7bfa21784715a7c2eedd58511128f09b7d90ab15c645b30b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "274a26aa6ea3813c7551a43f8f9176293eb20ce87e813fb86d6ee4de08daf7d5"
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
