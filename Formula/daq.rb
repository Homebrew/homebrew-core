class Daq < Formula
  desc "Network intrusion prevention and detection system"
  homepage "https://www.snort.org/"
  url "https://github.com/snort3/libdaq/archive/v3.0.9.tar.gz"
  mirror "https://fossies.org/linux/misc/libdaq-3.0.9.tar.gz"
  sha256 "c0e8535533720a6df05ab884b7c8f5fb4222f3aac12bdc11829e08c79716d338"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/snort3/libdaq.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ff4e8cf721ee25800c76a84da783de4460a60d4dda8e52ee97e197e9f80ed103"
    sha256 cellar: :any,                 arm64_monterey: "d4130b24a54d1970abc80c78fe0700a7d1439342cadf0954b670d409c9e6e056"
    sha256 cellar: :any,                 arm64_big_sur:  "c571650f05f056057fb4fa371a65324f69b8ee4e92141d2cc89f6b62ad0635e7"
    sha256 cellar: :any,                 ventura:        "33970a226a1fa18c0d5fbc28c269050901c71b0ad2d50f3fc72769143bed77ad"
    sha256 cellar: :any,                 monterey:       "73ee328396478fb0917831243ac4062fd3376d2677d37c18df9541b1f8aed8d2"
    sha256 cellar: :any,                 big_sur:        "621808c8004d6844e9160ada9d3de4f56bfbea57930ae457e5357335013cfa5a"
    sha256 cellar: :any,                 catalina:       "c4614ecbb53985794c77cfc44c86717ff7fd735c4f101e716952e5ae789f9f11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fa22f3ac5214ab8698ca7062956b78124f2da89de1fb8b6857b3aa5c8af863c"
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
