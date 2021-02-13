class Libfreenect < Formula
  desc "Drivers and libraries for the Xbox Kinect device"
  homepage "https://openkinect.org/"
  url "https://github.com/OpenKinect/libfreenect/archive/v0.6.2.tar.gz"
  sha256 "e135f5e60ae290bf1aa403556211f0a62856a9e34f12f12400ec593620a36bfa"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/OpenKinect/libfreenect.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "021f48f3afc226600529f465816d6448ee8033a56ad308a5e26bbae74c8008ea"
    sha256 cellar: :any, big_sur:       "bc7f17d9146bf0bd83edae5ff498b2b24e4715dfe6d944d2fba9a699375aa299"
    sha256 cellar: :any, catalina:      "9b149ef4c0f3d06cc95e1dcf77d87d88302241173cd9ce80c49655bb08b1a21d"
    sha256 cellar: :any, mojave:        "d4d3989b02368cc8b0b81bff675e2d8bd15a308c7087aec7d94782ab399437ae"
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
