class Libfreenect < Formula
  desc "Drivers and libraries for the Xbox Kinect device"
  homepage "https://openkinect.org/"
  url "https://github.com/OpenKinect/libfreenect/archive/v0.5.5.tar.gz"
  sha256 "0d7fd69da254f3624848a31c3041dcb8b714a84110b5b6bbb59498c4ffdeafde"
  head "https://github.com/OpenKinect/libfreenect.git"

  bottle do
    cellar :any
    sha256 "4fd9e1385c35157288875419a1893df94cc08a3a8e888f1fe3a7a8d3d213b737" => :sierra
    sha256 "cb74a0b8ef6efafe3dabb008958e3c7a8b1704a6e1930b50bef61f164c6d2207" => :el_capitan
    sha256 "bb3ee8b4cd9ef4c57432f89a070b0b85e32ff0d8971715eb1de07041ecbd0f10" => :yosemite
    sha256 "f714532e1b21365063746846544a340dac70cf0c5cc877a207dd17284ee100b7" => :mavericks
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
