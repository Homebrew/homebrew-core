class Geographiclib < Formula
  desc "C++ geography library"
  homepage "https://geographiclib.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/geographiclib/distrib/GeographicLib-1.50.1.tar.gz"
  sha256 "d1765009e068b8cc5e76957e5d6be45ce6cff08c4aad8e5995e84a28354385f1"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "02ab2c5d659b1a1a2feb99cdf37635a20abc6747aadb25c5849dcb2f41563274" => :catalina
    sha256 "3ae437ffb71cebfb80137603de10c69c33ba9ea9ba820fb00a1c136b66c158dc" => :mojave
    sha256 "aeaf0148b41ba77b5f91221f0058326e6ca6be3de569966fe2d593e1200b451a" => :high_sierra
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
