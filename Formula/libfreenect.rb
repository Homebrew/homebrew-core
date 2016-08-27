class Libfreenect < Formula
  desc "Drivers and libraries for the Xbox Kinect device"
  homepage "https://openkinect.org/"
  url "https://github.com/OpenKinect/libfreenect/archive/v0.5.4.tar.gz"
  sha256 "de85e38ce195b693b4528880a843456c1d2c219b036bd1aa8dd36d11f58e5bc3"
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
