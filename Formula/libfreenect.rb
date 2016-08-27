class Libfreenect < Formula
  desc "Drivers and libraries for the Xbox Kinect device"
  homepage "https://openkinect.org/"
  url "https://github.com/OpenKinect/libfreenect/archive/v0.5.4.tar.gz"
  sha256 "de85e38ce195b693b4528880a843456c1d2c219b036bd1aa8dd36d11f58e5bc3"
  head "https://github.com/OpenKinect/libfreenect.git"

  bottle do
    cellar :any
    sha256 "967c297b1f854e88fd7b4660a5e6ab16c3d2cecfaf927f5ae69943e5bf43798b" => :el_capitan
    sha256 "6a137ed0771e4509af69abf597a8d232495c00756aa34f8d7278b2faee40f41a" => :yosemite
    sha256 "cfdde7367e5409cf2f9e38f1c0f095d3be643f3adf4e20e20c9bf458d6eca8c2" => :mavericks
  end

  option :universal

  depends_on "cmake" => :build
  depends_on "libusb"

  # PR 27 Aug 2016 "Fix clang build error 'ambiguous call to abs'"
  patch do
    url "https://github.com/OpenKinect/libfreenect/pull/480.patch"
    sha256 "32df40e2348027a4315fcd641b7384836334f8208bca85856ebc7033884df226"
  end

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
