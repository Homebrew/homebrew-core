class Daq < Formula
  desc "Network intrusion prevention and detection system"
  homepage "https://www.snort.org/"
  url "https://github.com/snort3/libdaq/archive/v3.0.7.tar.gz"
  mirror "https://fossies.org/linux/misc/libdaq-3.0.7.tar.gz"
  sha256 "e3af1ef17d764294ae428e662f7d2a6187a0085c6e0f15fc230e754a298cabe2"
  license "GPL-2.0-only"
  head "https://github.com/snort3/libdaq.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d9b3ee5412c02960d47e7ec751a77cb7db4c90248e8d0acc86b5109706b94d9a"
    sha256 cellar: :any,                 arm64_big_sur:  "de7c31db17594cfe76b75b247959bd6771c1deacdd4c170e227e88745ecdf350"
    sha256 cellar: :any,                 monterey:       "7f3cc6fc33f45e6f30fb87be6687d85f137b0e2b0e23144e67c0d72f040c9adb"
    sha256 cellar: :any,                 big_sur:        "b19e476f082f9e81038faa89b6f949b382bcac25a688325e5e28973b7367376d"
    sha256 cellar: :any,                 catalina:       "0b3e1622d7fa64426a06b9d9e2055a4a54c06cd4027a9ea3621eacda242c380e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c90c7b2ca952f926fd80f70612b1b1084fed2cfddc08634266e628ede24ea15"
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
