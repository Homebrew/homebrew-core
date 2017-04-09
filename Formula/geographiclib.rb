class Geographiclib < Formula
  desc "C++ geography library"
  homepage "https://geographiclib.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/geographiclib/distrib/GeographicLib-1.48.tar.gz"
  sha256 "7203d56123b6f6fb31842295d57b2418f79fb0db9a06f2f65ee9e415c6f0cb70"

  bottle do
    cellar :any
    sha256 "770c42edeb45da2841521537e1ee7fd2d3eca43357cf3abdad370cc98176bdc7" => :sierra
    sha256 "b268720abdb507078ddbb8a524db8e2c66c9eddea06d34949408481de59ffe0c" => :el_capitan
    sha256 "ce513ba1d5ca82caaf734d858bdd101214cbc7d2dc9d76dd2bd1a3fbeee08652" => :yosemite
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
