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

  HAS_PYTHON2 = true
  if MacOS.version <= :snow_leopard
    depends_on :python => :optional
    HAS_PYTHON2 = build.with? :python
  end

  depends_on :python3 => :optional
  HAS_PYTHON3 = build.with? :python3

  if HAS_PYTHON2 || HAS_PYTHON3
    depends_on "cython" => :build
    depends_on "numpy"
  end

  def install
    args = std_cmake_args
    args << "-DBUILD_OPENNI2_DRIVER=ON"
    args << "-DBUILD_PYTHON2=#{HAS_PYTHON2 ? "ON" : "OFF"}"
    args << "-DBUILD_PYTHON3=#{HAS_PYTHON3 ? "ON" : "OFF"}"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    system bin/"fakenect-record", "-h"
  end
end
