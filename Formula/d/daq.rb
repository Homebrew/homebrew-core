class Daq < Formula
  desc "Network intrusion prevention and detection system"
  homepage "https://www.snort.org/"
  url "https://github.com/snort3/libdaq/archive/refs/tags/v3.0.23.tar.gz"
  mirror "https://fossies.org/linux/misc/libdaq-3.0.23.tar.gz"
  sha256 "693e4709610432998c9c6ed5eb820525a5bad2fdbe610b10ef85e442376a3271"
  license "GPL-2.0-only"
  head "https://github.com/snort3/libdaq.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2b696a54388217c2b9103be923c891503fee81861ece74ecc247b5478f7e0994"
    sha256 cellar: :any,                 arm64_sequoia: "9de00a55269c89325806f6161e26af2a6e00bef6ca4d3d4690ec90711a830a33"
    sha256 cellar: :any,                 arm64_sonoma:  "2a0049a4ac183b580719c8f65a739f3646861cc5bee7709c62eaba5a5112b0e5"
    sha256 cellar: :any,                 sonoma:        "68fdcf2348ac47005c0cd91b6ae6f3de4d5a2fd2661c46dda343b55462adcfb8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7822cfada66dd65220f53408c0adfe401fd94fcb44dadda6b8a7d41f627ae772"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e65d8282faf127579dae3dd398694a604250178b7e0c5fee0730fdfa6d93cc3"
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
