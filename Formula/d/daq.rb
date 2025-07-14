class Daq < Formula
  desc "Network intrusion prevention and detection system"
  homepage "https://www.snort.org/"
  url "https://github.com/snort3/libdaq/archive/refs/tags/v3.0.20.tar.gz"
  mirror "https://fossies.org/linux/misc/libdaq-3.0.20.tar.gz"
  sha256 "42730cb427695d4049deaa667623036b3915eaa651bcb91493ca450f06bb36b3"
  license "GPL-2.0-only"
  head "https://github.com/snort3/libdaq.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "53b81cccef754c485d9b9490d8370e66e635aad54d5cae177f9670b696f3efe5"
    sha256 cellar: :any,                 arm64_sonoma:  "bfb7ff5160c7a92c2ca0a05bc48e6f8a0d31b2baa0e69e0d01d52b8d5146f41b"
    sha256 cellar: :any,                 arm64_ventura: "3c438e99a6dbae1f9beb74858e14ccfb8ded36f9f61b495b097a4e4da5b86739"
    sha256 cellar: :any,                 sonoma:        "0564b9292a07f73e12d3719977d4d881f805cd32be466048a8737783dfd88e3c"
    sha256 cellar: :any,                 ventura:       "4f4d87d513a0c623d0215e418be924df17765e0c8d3fa53a4d17d79c818ee82c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "195847be1474de3f89ddd034355fca2202416ce9721923a634d0200d296c777a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8abbc1fb066314bc5eee062f86e7c066ad6fce6a52ac9f5fbb7b3c668981187e"
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
