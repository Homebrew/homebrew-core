class Daq < Formula
  desc "Network intrusion prevention and detection system"
  homepage "https://www.snort.org/"
  url "https://github.com/snort3/libdaq/archive/refs/tags/v3.0.16.tar.gz"
  mirror "https://fossies.org/linux/misc/libdaq-3.0.16.tar.gz"
  sha256 "20c641c5a8a6c230c2753eb3e0b1b493810942dbd4b1828a4462bb18a4f43f82"
  license "GPL-2.0-only"
  head "https://github.com/snort3/libdaq.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "ba2920fbcb126b556b281ee8c93ba65674ee4f2f61bd8d15d2c00d51caa20cb5"
    sha256 cellar: :any,                 arm64_sonoma:   "56ffd6bde4a21115ed0f56b5d885987620185ae3e87023a7d7dc93baf14714c5"
    sha256 cellar: :any,                 arm64_ventura:  "f4b7323cc11e7757b64ad35cfc15bfe8da536ca53db54fbc142981ed54b2f9bc"
    sha256 cellar: :any,                 arm64_monterey: "6c728dfaf576071e4d5013f4beb7c3f927f0f19e22f33deda9b643537dfd1168"
    sha256 cellar: :any,                 sonoma:         "91941c2be144e6da116150841034b3020da3bcaa6592aa077941f0ade9164278"
    sha256 cellar: :any,                 ventura:        "62b8545946e6e9ab4e4eb2e3905f6fc798cb566a9993b4f9ca38fcfc3597b607"
    sha256 cellar: :any,                 monterey:       "056783898fb32fe292edb380d238dae45f35e6bd997ebb725789539573c5ce6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85f28b42b340f0c4d5f1b9fd9b569de64b593d8c55170745e71f3b36bd4acd94"
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
