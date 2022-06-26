class Daq < Formula
  desc "Network intrusion prevention and detection system"
  homepage "https://www.snort.org/"
  url "https://github.com/snort3/libdaq/archive/v3.0.9.tar.gz"
  mirror "https://fossies.org/linux/misc/libdaq-3.0.9.tar.gz"
  sha256 "c0e8535533720a6df05ab884b7c8f5fb4222f3aac12bdc11829e08c79716d338"
  license "GPL-2.0-only"
  head "https://github.com/snort3/libdaq.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1a963ac9b6dd33dda01a3a59b5e78a0ac5f9e9548c70bb230bc28c980c58b61d"
    sha256 cellar: :any,                 arm64_big_sur:  "526d1a7cc5f258caabaacc684a8e4888c881a32e1095c2aec66c9100b459ee63"
    sha256 cellar: :any,                 monterey:       "a3abe4b20f9cd886cc2d473a9010065de9b293156895ecaff41a991313cc3188"
    sha256 cellar: :any,                 big_sur:        "cc472d0fecf5739b6a0e528aa94033cfa1095f863ad0187a59f38dc191cc1c4c"
    sha256 cellar: :any,                 catalina:       "98f0fbe2af7177937ff3aaeb2fb0846cff2b3049a7ad127cfd82a02bc8bfd3a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f7bfc74cc962bc559d07584be350516a73838dcaeb024adb5605ecba3c9392a"
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
