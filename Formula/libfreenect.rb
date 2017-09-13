class Libfreenect < Formula
  desc "Drivers and libraries for the Xbox Kinect device"
  homepage "https://openkinect.org/"
  url "https://github.com/OpenKinect/libfreenect/archive/v0.5.6.tar.gz"
  sha256 "5ec1973cd01fd864f4c5ccc84536aa2636d0be768ba8b1c2d99026f3cd1abfd3"
  head "https://github.com/OpenKinect/libfreenect.git"

  bottle do
    cellar :any
    sha256 "5b15e3bc7e75c5916b236be3f4c42929302f47edc2d269e7a76131ea4fec1939" => :sierra
    sha256 "46af9983bad90585eb9eafb10b08af0f5d4b27d57d392f4a327719ac4338fea8" => :el_capitan
    sha256 "985526f21c7730bd63b213151fefec7a87f134a89c44dcfc0ee14abfcab31a62" => :yosemite
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
