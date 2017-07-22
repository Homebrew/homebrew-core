class Libfreenect < Formula
  desc "Drivers and libraries for the Xbox Kinect device"
  homepage "https://openkinect.org/"
  url "https://github.com/OpenKinect/libfreenect/archive/v0.5.6.tar.gz"
  sha256 "5ec1973cd01fd864f4c5ccc84536aa2636d0be768ba8b1c2d99026f3cd1abfd3"
  head "https://github.com/OpenKinect/libfreenect.git"

  bottle do
    cellar :any
    sha256 "4fd9e1385c35157288875419a1893df94cc08a3a8e888f1fe3a7a8d3d213b737" => :sierra
    sha256 "cb74a0b8ef6efafe3dabb008958e3c7a8b1704a6e1930b50bef61f164c6d2207" => :el_capitan
    sha256 "bb3ee8b4cd9ef4c57432f89a070b0b85e32ff0d8971715eb1de07041ecbd0f10" => :yosemite
    sha256 "f714532e1b21365063746846544a340dac70cf0c5cc877a207dd17284ee100b7" => :mavericks
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
