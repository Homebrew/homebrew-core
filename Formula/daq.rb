class Daq < Formula
  desc "Network intrusion prevention and detection system"
  homepage "https://www.snort.org/"
  url "https://github.com/snort3/libdaq/archive/v3.0.11.tar.gz"
  mirror "https://fossies.org/linux/misc/libdaq-3.0.11.tar.gz"
  sha256 "c9b691e113960cc19c4df6e93eacbdb45c96491da9c81471f3e419b91c04579a"
  license "GPL-2.0-only"
  head "https://github.com/snort3/libdaq.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fd44afd560e9e180276083f31bd77198600a2507028d307e0d2288754de9aee6"
    sha256 cellar: :any,                 arm64_monterey: "c6d7d20b3ee226ec94a68aca384ed3f6d046b0a9426fbfd275d7fc1ed736dccb"
    sha256 cellar: :any,                 arm64_big_sur:  "b7ce381c9697eec7e7003089eaf0ae7d737e546f2bb0674d753a449fa77532bb"
    sha256 cellar: :any,                 ventura:        "49dbcf8efe3c9bf4967d6a1116446551ba0caa9a7e7f9f9dc57990f459391857"
    sha256 cellar: :any,                 monterey:       "10bd75ee44af3314d39b271504d164d7247335d8cb9347e05a2e8b6fbbb55ee3"
    sha256 cellar: :any,                 big_sur:        "ebf01fc18da931fec77d2b5fbb02cce0fb8f78f83e9e23875205f826b71e6249"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27b239d97fc7b83dd62fc9361a6e4a5f4686d15601d1b62d7c329b35053f2de9"
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
