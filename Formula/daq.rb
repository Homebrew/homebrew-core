class Daq < Formula
  desc "Network intrusion prevention and detection system"
  homepage "https://www.snort.org/"
  url "https://github.com/snort3/libdaq/archive/v3.0.4.tar.gz"
  mirror "https://fossies.org/linux/misc/libdaq-3.0.4.tar.gz"
  sha256 "a376c7625d1442ddb7e3c75954c910cc9d64440e2f8f345981aa5fa6999ea206"
  license "GPL-2.0-only"
  head "https://github.com/snort3/libdaq.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "59174c893c54717c09ba73f6d3455cddf42e9ef8b9de405b6e7b115dd08961b7"
    sha256 cellar: :any,                 big_sur:       "add510dd1048bd47451b086020aa64326cbb272e317598ac35394cd74ec36fe1"
    sha256 cellar: :any,                 catalina:      "c9b6281bb8e20fd935b734f9cacdca7f2528356a90b2614ad8dc164870dcc4cc"
    sha256 cellar: :any,                 mojave:        "4d3f5ade023a0021385619c66507cdf5b322d837c99d0eec4b1778c78fbbdd77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b16f5e49e6ba2ddb8c4a078f9139cc5f64bc953f60c909efd519c9da088f522"
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
