class Libfreenect < Formula
  desc "Drivers and libraries for the Xbox Kinect device"
  homepage "https://openkinect.org/"
  url "https://github.com/OpenKinect/libfreenect/archive/v0.5.7.tar.gz"
  sha256 "5f22c9a0260efd5a31d8e6465bb06b2b389f61b8f7714e0b42b7b20314e5ef59"
  head "https://github.com/OpenKinect/libfreenect.git"

  bottle do
    cellar :any
    sha256 "1785eb110c7b3144bf80ad66e83125f4631655792134b673ca64a551cc31fc12" => :high_sierra
    sha256 "dcfd6d414d14d98f292e60d9a7000d479ce4562f83d34745ac63841bd9b40d2c" => :sierra
    sha256 "75f6dfd0a873c4268bc766f4fdc7607fb456118e164a0fdb45f37179adb768b8" => :el_capitan
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
