class Daq < Formula
  desc "Network intrusion prevention and detection system"
  homepage "https://www.snort.org/"
  url "https://github.com/snort3/libdaq/archive/refs/tags/v3.0.21.tar.gz"
  mirror "https://fossies.org/linux/misc/libdaq-3.0.21.tar.gz"
  sha256 "60ad9405c1c6b75955e0784511b173570a601491ccdb6399da53ca811c446a96"
  license "GPL-2.0-only"
  head "https://github.com/snort3/libdaq.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dd1c882f91f69810f19b796c223dade48cef32c16a8384c87e14ba43a94f3457"
    sha256 cellar: :any,                 arm64_sequoia: "a31103738088040c119a6c928d672e9d7850bd559a8d5ec34e021d6ada529b93"
    sha256 cellar: :any,                 arm64_sonoma:  "64b327ce1b26052302ffad7a91262cff734a62e3834197abb846c65ea7b90916"
    sha256 cellar: :any,                 arm64_ventura: "111f99b9a9a16d7fbb4eb1cbd72da7ea8a4ab9bbdec31609cfd81941716e924a"
    sha256 cellar: :any,                 sonoma:        "5be0087b396a54e4f15b6a449bccdc0924ab4fe2e087182a66619b51315b89ec"
    sha256 cellar: :any,                 ventura:       "644fd14758656d2fa0ee57d93f0d5002f2bf8b68892c271c351e96db5f8b7937"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b7f3e4fd9bad98b570e98396c40e671f2fc6922abf7729c995fcd52ef8f8b67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfac765b31161f237bbd8d7fa19b7a83d3330765975db2dfaa536eebac39e35b"
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
