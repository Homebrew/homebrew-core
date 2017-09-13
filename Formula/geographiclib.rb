class Geographiclib < Formula
  desc "C++ geography library"
  homepage "https://geographiclib.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/geographiclib/distrib/GeographicLib-1.48.tar.gz"
  sha256 "7203d56123b6f6fb31842295d57b2418f79fb0db9a06f2f65ee9e415c6f0cb70"

  bottle do
    cellar :any
    sha256 "f330164f390a5a55cb8b14e8e5ec3d140c0a5563d3365608e7068dd09542cb2d" => :sierra
    sha256 "bd02a5b4a1ed096d7ae1ae7df893fa8e17fecdf537173aeb34682a014309cad8" => :el_capitan
    sha256 "a5fc291555d18dcd2c80a6ea3f7ff77337b8c60cc016c07c2cda52599bf1c963" => :yosemite
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
