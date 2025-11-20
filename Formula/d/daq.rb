class Daq < Formula
  desc "Network intrusion prevention and detection system"
  homepage "https://www.snort.org/"
  url "https://github.com/snort3/libdaq/archive/refs/tags/v3.0.22.tar.gz"
  mirror "https://fossies.org/linux/misc/libdaq-3.0.22.tar.gz"
  sha256 "27357554c8fcf03b11309773e594e4d7e614752cfe1a00e663b704c5331c21de"
  license "GPL-2.0-only"
  head "https://github.com/snort3/libdaq.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1b55bc1fa94a2393603ca943fb0d3ed2f04dcea82dbeaed01659684107559f0f"
    sha256 cellar: :any,                 arm64_sequoia: "319746f4659fedc2ded4c649360db3332cf299054a3d8215eebbd0d191221681"
    sha256 cellar: :any,                 arm64_sonoma:  "183401aa1bdea524c064d9fd0b834e4da748c49f4a4a5f3ea4a6b83cbe908022"
    sha256 cellar: :any,                 sonoma:        "6ede97940581cf24c0ee0ec4c4ec9ce8748b3e8df8f01d9e0d228ec49f2d7c57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6738b632f4f718aaf8b6338d91df5f781130689d4e529b207aead22e26715d40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e45fcf4ec339b7f2d6b617670d1fedd2e778c2836a75697580978641c34556e"
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
