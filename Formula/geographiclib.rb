class Geographiclib < Formula
  desc "C++ geography library"
  homepage "https://geographiclib.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/geographiclib/distrib/GeographicLib-1.50.tar.gz"
  sha256 "2ac8888094d21ba48adb433c4bb569937497b39733e96c080b5ce278e2587622"

  bottle do
    cellar :any
    sha256 "e23bb56aa73167450ab7f43ca7f00fb334729fa533a0b1c5e1d14a2d970f415c" => :catalina
    sha256 "5c7c3e1686f06107ea12cffeffae30e22c63a199b1b36ba5a68dcfad812277b9" => :mojave
    sha256 "65dd48aba3d3697283c608f46ec262cdf99bf1f08db2a599bb191962609dcd4b" => :high_sierra
    sha256 "cb19d70deee081b876d7c004f0bea3d903a54897f5bc56cb5d3009faafc05659" => :sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"GeoConvert", "-p", "-3", "-m", "--input-string", "33.3 44.4"
  end
end
