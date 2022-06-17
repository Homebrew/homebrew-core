class Daq < Formula
  desc "Network intrusion prevention and detection system"
  homepage "https://www.snort.org/"
  url "https://github.com/snort3/libdaq/archive/v3.0.9.tar.gz"
  mirror "https://fossies.org/linux/misc/libdaq-3.0.9.tar.gz"
  sha256 "c0e8535533720a6df05ab884b7c8f5fb4222f3aac12bdc11829e08c79716d338"
  license "GPL-2.0-only"
  head "https://github.com/snort3/libdaq.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "52f0c3a1ec708b77312bd28d9cb36bb7a1c83707b178c49e9ef80bb1670662fe"
    sha256 cellar: :any,                 arm64_big_sur:  "3dad1903959fe048a7b131c7c4bdc0c730b0cf6e73f211b98736949ba624a664"
    sha256 cellar: :any,                 monterey:       "e445da3b4e68058a9f0f9c96548542790bf9af3bbdd2ff223f8db65d1b6417c3"
    sha256 cellar: :any,                 big_sur:        "9e12aa54ccca7ca08e2538d94497db4fbeec60716c7d62fcf5f592f82e04084f"
    sha256 cellar: :any,                 catalina:       "2b9c7080aaf0fbfd55057a01207c3cd4f7d905c895c539675962bc5985c80edf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ce0a3cc2bf25659e1d97b4524a4b03e3b33cf99fd5f21318ca8f0044c519360"
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
