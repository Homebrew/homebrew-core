class Libbladerf < Formula
  desc "USB 3.0 Superspeed Software Defined Radio Source"
  homepage "https://nuand.com/"
  url "https://github.com/Nuand/bladeRF.git",
    tag:      "2019.07",
    revision: "991bba2f9c4d000f000077cc465878d303417e26"
  license "GPL-2.0"
  head "https://github.com/Nuand/bladeRF.git"

  bottle do
    sha256 "a60bfb3c0e350ec8fc1774b902bb8e151581f11a6669d067cb94da417e266bc3" => :catalina
    sha256 "47cc541e8c1e2061cb842595f08cd9adc65194378bf1303d876e79e6c5a93b85" => :mojave
    sha256 "f276e5ce4058bd486edaff6b97f61bddea9f44b5f88f35997a90c100da8f70d1" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    ENV.prepend "CFLAGS", "-I#{MacOS.sdk_path}/usr/include/malloc"
    mkdir "host/build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"bladeRF-cli", "--version"
  end
end
