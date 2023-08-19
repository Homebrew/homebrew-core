class Daq < Formula
  desc "Network intrusion prevention and detection system"
  homepage "https://www.snort.org/"
  url "https://github.com/snort3/libdaq/archive/v3.0.12.tar.gz"
  mirror "https://fossies.org/linux/misc/libdaq-3.0.12.tar.gz"
  sha256 "dedfdb88de151d61009bdb365322853687b1add4adec248952d2a93b70f584af"
  license "GPL-2.0-only"
  head "https://github.com/snort3/libdaq.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2752cb5fd1ee45a9a25ccd310651b0b2e745c032d04a5a8cc531cc2f3fd25093"
    sha256 cellar: :any,                 arm64_monterey: "fa8d591b347cf3693a617c9204a2d98ba2f75f3d6446d41570517820fdfbf793"
    sha256 cellar: :any,                 arm64_big_sur:  "2e7508f3b0ec6c7e765a5675b664691222d43e4fc1a978fbfc27b27e488a7de3"
    sha256 cellar: :any,                 ventura:        "4991c09473603d858f12446c74104e38a2f88f785d704aa8398aa013301acf4d"
    sha256 cellar: :any,                 monterey:       "56ffd541b4d7ea8a6d0a36fbafa188adef55ac983238899005b52355957a86a2"
    sha256 cellar: :any,                 big_sur:        "76e1c084f63146206bcb8a72ded19a09a85b1c678299a155e194edce7edef657"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b45623eb8ce77cb9ee62c84764463d657b369b55c3ad78a9e6cc180750db403b"
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
