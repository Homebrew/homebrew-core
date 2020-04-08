class Libfreenect < Formula
  desc "Drivers and libraries for the Xbox Kinect device"
  homepage "https://openkinect.org/"
  url "https://github.com/OpenKinect/libfreenect/archive/v0.6.0.tar.gz"
  sha256 "5300f29d9fb8bb466efbc34c01f0045ed0f616278907e507ccd8c2afdea331c8"
  head "https://github.com/OpenKinect/libfreenect.git"

  bottle do
    cellar :any
    sha256 "d08e8a7ab00170279a9dcddeb6dc25c32a13e52c2f1840e0bed4214cb9c3b0f9" => :catalina
    sha256 "9dd21ad2debf956fc358c7087503d12b8cdf66ae4fc23fdbeeb7426a3a01b380" => :mojave
    sha256 "165eb222b47c95b1a1d6853af0fb658c419420816c2b70ce036eacb5713d9737" => :high_sierra
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
