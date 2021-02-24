class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  # NOTE: Please keep these values in sync with ilmbase.rb when updating.
  url "https://github.com/openexr/openexr/archive/v2.5.5.tar.gz"
  sha256 "59e98361cb31456a9634378d0f653a2b9554b8900f233450f2396ff495ea76b3"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_big_sur: "b484c97399b2317707c2685fceeb4e8ba26b9eea3d0311ebcf26f90b04ad5fb8"
    sha256 big_sur:       "e304133fc11a65212122e299f49cee78f1fb72184fee7f595da207eec320d8d4"
    sha256 catalina:      "c0909e409936c154b16e5d6c0564a495733908d5b98e4d3ef28143f88b7a15e9"
    sha256 mojave:        "75479d518e17091a00fb198fecfcfbc5d0905fac31896473b75bebd85f165f75"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ilmbase"

  uses_from_macos "zlib"

  resource "exr" do
    url "https://github.com/openexr/openexr-images/raw/master/TestImages/AllHalfValues.exr"
    sha256 "eede573a0b59b79f21de15ee9d3b7649d58d8f2a8e7787ea34f192db3b3c84a4"
  end

  def install
    cd "OpenEXR" do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    resource("exr").stage do
      system bin/"exrheader", "AllHalfValues.exr"
    end
  end
end
