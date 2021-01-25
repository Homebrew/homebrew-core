class Libfreenect < Formula
  desc "Drivers and libraries for the Xbox Kinect device"
  homepage "https://openkinect.org/"
  url "https://github.com/OpenKinect/libfreenect/archive/v0.6.1.tar.gz"
  sha256 "a2e426cf42d9289b054115876ec39502a1144bc782608900363a0c38056b6345"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  revision 1
  head "https://github.com/OpenKinect/libfreenect.git"

  bottle do
    cellar :any
    sha256 "bc7f17d9146bf0bd83edae5ff498b2b24e4715dfe6d944d2fba9a699375aa299" => :big_sur
    sha256 "021f48f3afc226600529f465816d6448ee8033a56ad308a5e26bbae74c8008ea" => :arm64_big_sur
    sha256 "9b149ef4c0f3d06cc95e1dcf77d87d88302241173cd9ce80c49655bb08b1a21d" => :catalina
    sha256 "d4d3989b02368cc8b0b81bff675e2d8bd15a308c7087aec7d94782ab399437ae" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "libusb"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                      "-DBUILD_OPENNI2_DRIVER=ON"
      system "make", "install"
    end
  end

  test do
    system bin/"fakenect-record", "-h"
  end
end
