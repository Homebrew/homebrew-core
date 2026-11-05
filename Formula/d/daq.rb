class Daq < Formula
  desc "Network intrusion prevention and detection system"
  homepage "https://www.snort.org/"
  url "https://github.com/snort3/libdaq/archive/refs/tags/v3.0.29.tar.gz"
  sha256 "136deba78d195163687eb71a6dc81b725c27fde7765b7ef70eb741c371e887a8"
  license "GPL-2.0-only"
  compatibility_version 1
  head "https://github.com/snort3/libdaq.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "30ded0080accc1f12e29b4478ab4230b8bbc91a1a72960bd84daf42cefc20b24"
    sha256 cellar: :any, arm64_tahoe:       "840d13d1d40d14a49178f292c243ee49b91879412fd2877b5fb922185fb02295"
    sha256 cellar: :any, arm64_sequoia:     "0e3ff47c6024e57199b0d9fb4e3e1a873c73c5d800cf379a5b1e43955aa1e9a6"
    sha256 cellar: :any, arm64_linux:       "27b1065702a8eb49e9e39d5b67deb187c78029e5db414799d0c8bc24072c9bcb"
    sha256 cellar: :any, x86_64_linux:      "62cfd8d1370dad00879c6cb5c284b29f94e1def98b023953991bd899f3ceaff0"
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
