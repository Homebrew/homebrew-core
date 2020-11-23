class Libfreenect < Formula
  desc "Drivers and libraries for the Xbox Kinect device"
  homepage "https://openkinect.org/"
  url "https://github.com/OpenKinect/libfreenect/archive/v0.6.1.tar.gz"
  sha256 "a2e426cf42d9289b054115876ec39502a1144bc782608900363a0c38056b6345"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/OpenKinect/libfreenect.git"

  bottle do
    cellar :any
    sha256 "a0521df86c4cc5aacf09ab589aacb36e8f58f058a33fe3b703788558b598b314" => :big_sur
    sha256 "a9098e0b3d868c85de4b0bb243d16200361002ff5d27d6d9c9bc5a08fb6ab95a" => :catalina
    sha256 "d150e4351036b1b3174d24c359736e04a3bbdbe966c77b1714f0edbef486d012" => :mojave
    sha256 "c08bad975cc7175fdf88a603fb300cac3493f0e20172fc99a69da568d4ad68ff" => :high_sierra
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
