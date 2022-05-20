class Daq < Formula
  desc "Network intrusion prevention and detection system"
  homepage "https://www.snort.org/"
  url "https://github.com/snort3/libdaq/archive/v3.0.7.tar.gz"
  mirror "https://fossies.org/linux/misc/libdaq-3.0.7.tar.gz"
  sha256 "e3af1ef17d764294ae428e662f7d2a6187a0085c6e0f15fc230e754a298cabe2"
  license "GPL-2.0-only"
  head "https://github.com/snort3/libdaq.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6134622f0d881a752dd52c54481f188026868d1d5df83ccb881b1ecc06226ed3"
    sha256 cellar: :any,                 arm64_big_sur:  "13f029804a664d28ba6443ab2d2b9c6dd59ed6b870946d3ccc1734ffe022caeb"
    sha256 cellar: :any,                 monterey:       "1203103b74dfd43731f233e70b856b33bce8f7a5df514e05a405101d8c8b8c13"
    sha256 cellar: :any,                 big_sur:        "5b1ae8880f97bc8020d03e4057ddaeb345755414c534e0fb5a43ea99689c4eac"
    sha256 cellar: :any,                 catalina:       "b16673133466e6fd4394a7e81a6c1effbb33ab6cef5b897ee6dfd1292c302bd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4bcbd83b743a5f422372e213fd9c5f2289c76801cf018926ceb030761542ed2"
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
