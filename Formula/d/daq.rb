class Daq < Formula
  desc "Network intrusion prevention and detection system"
  homepage "https://www.snort.org/"
  url "https://github.com/snort3/libdaq/archive/refs/tags/v3.0.24.tar.gz"
  mirror "https://fossies.org/linux/misc/libdaq-3.0.24.tar.gz"
  sha256 "3adfd578181ef8978245e9a760b68e2fa02a7f0e3893c2e6c4bf098da633923c"
  license "GPL-2.0-only"
  head "https://github.com/snort3/libdaq.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d6c7a89226ca0a2e30bf71533a81bb6e6174aef8b70cf987d7bf244e2b6d4377"
    sha256 cellar: :any,                 arm64_sequoia: "8859f1213c56709ba8e0916bdeb36464e3a73977cd8c4461c51a633794386e5b"
    sha256 cellar: :any,                 arm64_sonoma:  "76e59c7cd7980c8948b0dd36a09983e2e38dda3b6f72f6b66bef5fddf1e332ce"
    sha256 cellar: :any,                 sonoma:        "3a4db6c4198b616c0f78465c6cc01bf74a02f58e2dffc908d5b447953cac4ef9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc6bab61296d49c8cbcfe29ba6413d6c78aaf3c6adb1e8d57e2710e3f0dd7b8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc16bbfbae954980fdfa40b2456fa28c7fc11ba98cdc350b62a016b5e4a561c6"
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
