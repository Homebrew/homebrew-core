class Airspy < Formula
  desc "The usemode driver and associated tools for airspy"
  homepage "https://airspy.com/"
  url "https://github.com/airspy/host/archive/v1.0.9.tar.gz"
  sha256 "967ef256596d4527b81f007f77b91caec3e9f5ab148a8fec436a703db85234cc"
  head "https://github.com/airspy/host.git"

  bottle do
    sha256 "d593672c7c08aff7b0056aa06171129b9fba717837de653dfb96b26ec78d6553" => :mojave
    sha256 "44736e1193e3f63fca0c984ac4f594d1ad11a83a810898103652f69af2bce63f" => :high_sierra
    sha256 "bfc1393f3efe5b58016fbee40a4048e7c7246203cb72b02261da1045941bcd4f" => :sierra
    sha256 "c86b265ed42d8a976ff4bfc6116e5945d103f22af8ced4b9a9a18827ecf4af06" => :el_capitan
    sha256 "1d6af7e52534bc50625eabcaa2b586e5824a3abbb4c3b42e032e5b4de41c6bfb" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    args = std_cmake_args

    libusb = Formula["libusb"]
    args << "-DLIBUSB_INCLUDE_DIR=#{libusb.opt_include}/libusb-1.0"
    args << "-DLIBUSB_LIBRARIES=#{libusb.opt_lib}/libusb-1.0.dylib"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/airspy_lib_version").chomp
  end
end
