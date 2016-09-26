class Airspy < Formula
  desc "The usemode driver and associated tools for airspy"
  homepage "http://www.airspy.com"
  url "https://github.com/airspy/host/archive/v1.0.9.tar.gz"
  sha256 "358fea19f90bde13babc57ee7fdefeff3d8d8f5d629b0891734c5d4e811e8e6b"
  head "https://github.com/airspy/host.git"

  bottle do
    sha256 "bfc1393f3efe5b58016fbee40a4048e7c7246203cb72b02261da1045941bcd4f" => :sierra
    sha256 "c86b265ed42d8a976ff4bfc6116e5945d103f22af8ced4b9a9a18827ecf4af06" => :el_capitan
    sha256 "1d6af7e52534bc50625eabcaa2b586e5824a3abbb4c3b42e032e5b4de41c6bfb" => :yosemite
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
