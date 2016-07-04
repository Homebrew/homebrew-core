class Airspy < Formula
  desc "The usemode driver and associated tools for airspy"
  homepage "http://www.airspy.com"
  url "https://github.com/airspy/host/archive/v1.0.8.tar.gz"
  sha256 "4ab00f2ae731a3cbc32ae653ef8a03d676ecea0e130a3c25c117c6e7d639a2db"
  head "https://github.com/airspy/host.git"

  bottle do
    sha256 "108f2a0123ddc224ebd636f40e0b11b04f7d6996779fd92fe9f553e7194fb486" => :el_capitan
    sha256 "42dae5b6a2ee6b2915a2b8bd4fad8b89b7d7786c03a589bcee0229699ab65207" => :yosemite
    sha256 "19d228309bbf9ad2e1daec70f018b6de29d6dec014dd80ee55ab9b23dfb23e26" => :mavericks
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "libusb"

  def install
    args = std_cmake_args

    libusb = Formula["libusb"]
    args << "-DLIBUSB_INCLUDE_DIR=#{libusb.opt_include}/libusb-1.0"
    args << "-DLIBUSB_LIBRARIES=#{libusb.opt_lib}/libusb-1.0.dylib"

    if build.universal?
      ENV.universal_binary
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/airspy_lib_version").chomp
  end
end
