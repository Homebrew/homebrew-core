class Libfreenect < Formula
  desc "Drivers and libraries for the Xbox Kinect device"
  homepage "https://openkinect.org/"
  url "https://github.com/OpenKinect/libfreenect/archive/v0.5.5.tar.gz"
  sha256 "0d7fd69da254f3624848a31c3041dcb8b714a84110b5b6bbb59498c4ffdeafde"
  head "https://github.com/OpenKinect/libfreenect.git"

  bottle do
    cellar :any
    sha256 "41e32a1ff503b4a7c8f797771976100014d862f4df95a6f2828deebdcfd34324" => :el_capitan
    sha256 "845f02fb8512b237c80a1d22cc1faa3a2a3a081eff5e2a529863373317b48c9b" => :yosemite
    sha256 "c3355ea3effc244a93d55715ebd0cdcc435c6bd369db9e8ab3aa37f11e4d65e1" => :mavericks
  end

  option :universal

  depends_on "cmake" => :build
  depends_on "libusb"

  def install
    args = std_cmake_args
    args << "-DBUILD_OPENNI2_DRIVER=ON"

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
    system bin/"fakenect-record", "-h"
  end
end
