class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.7.9/poco-1.7.9p1-all.tar.gz"
  sha256 "463f58aac40a7f7f28950b2c5bfe6c25a0dc61a70e5269a2be8c35d76fcbea84"

  head "https://github.com/pocoproject/poco.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "75a6e3def5051efd5ed03d1afaf8727a3bd7fbc6ac1c9da3151e322df3fc0d3c" => :high_sierra
    sha256 "11f9cb54eeb5204f4fdce65eacc403be2cf6c8999b27362922b9428253a81307" => :sierra
    sha256 "d369e4da0d1acc3ad5d6249390cb0a459f4d2723f8bdd49a4bbbc75dffae65f8" => :el_capitan
  end

  option "with-static", "Build static libraries (instead of shared)"

  depends_on "openssl"
  depends_on "cmake" => :build

  def install
    ENV.cxx11

    args = std_cmake_args
    args << "-DENABLE_DATA_MYSQL=OFF" << "-DENABLE_DATA_ODBC=OFF"
    args << "-DPOCO_STATIC=ON" if build.with? "static"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    system bin/"cpspc", "-h"
  end
end
