class Daq < Formula
  desc "Network intrusion prevention and detection system"
  homepage "https://www.snort.org/"
  url "https://github.com/snort3/libdaq/archive/v3.0.11.tar.gz"
  mirror "https://fossies.org/linux/misc/libdaq-3.0.11.tar.gz"
  sha256 "c9b691e113960cc19c4df6e93eacbdb45c96491da9c81471f3e419b91c04579a"
  license "GPL-2.0-only"
  head "https://github.com/snort3/libdaq.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f59add6ce57fcd5835995a45c15fc608ff15a8693582074b8a12660121a19e42"
    sha256 cellar: :any,                 arm64_monterey: "b2090e6a4e6b2cd40abb688f3416ec9892b801c2e1617d24270224a0ef5efe1b"
    sha256 cellar: :any,                 arm64_big_sur:  "c09cf711da63e9259b5c95b3317c1c5658b2b3fe8ee9e266bd171f1f396bc8ba"
    sha256 cellar: :any,                 ventura:        "9a3b45972bd73b63a0912aea5c3ba2ccb235b75b84848726ac42c9134c3305ea"
    sha256 cellar: :any,                 monterey:       "d98c41b03d2f5268dc1901919662d408f76bef763c0dd0e6a6c3a5156d962620"
    sha256 cellar: :any,                 big_sur:        "e6b2d1d2409ad3e531536583ea6ebc23ba6e34e8a44996572a480f8e8c6a75b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55b30b45474b276705ae18e775b5f34392bf6c86fdd58edf39acfcea1a6bac52"
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
