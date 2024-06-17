class Daq < Formula
  desc "Network intrusion prevention and detection system"
  homepage "https://www.snort.org/"
  url "https://github.com/snort3/libdaq/archive/refs/tags/v3.0.15.tar.gz"
  mirror "https://fossies.org/linux/misc/libdaq-3.0.15.tar.gz"
  sha256 "174c639d59f7bda84d71bda50257febbb2646138aa7bbf948bb4d4a8be60f2d8"
  license "GPL-2.0-only"
  head "https://github.com/snort3/libdaq.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2bff8d875c244a57cb29026e9fd16f21ba9393ed5b080f3af9733db42e5379c1"
    sha256 cellar: :any,                 arm64_ventura:  "67a37086842de0572b33d128312d9d140aa969f12140f16b0668eba18340c018"
    sha256 cellar: :any,                 arm64_monterey: "66afe818e9a4009512cb66b40d2d1ffbac16f246b54f90583876a5f516411ad5"
    sha256 cellar: :any,                 sonoma:         "4c65d0b5f6d58a55eecc6b53354bfa325272564de38460974bcb55620e4495dd"
    sha256 cellar: :any,                 ventura:        "c94f842e9d8bac8e53a48018661b5b9205cd31955952f24788ce1dc9d2b5c359"
    sha256 cellar: :any,                 monterey:       "0d5fc669460512586e51f642500a4a7c7ca4e097831c97ef8c32d134197c4c02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff7bd173abe5e325ec61c73d6bb54b18fd7fe28a87339be110b708a7a67c0746"
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
