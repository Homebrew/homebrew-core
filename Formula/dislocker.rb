class Dislocker < Formula
  desc "FUSE driver to read/write Windows' BitLocker-ed volumes"
  homepage "https://github.com/Aorimn/dislocker"
  url "https://github.com/Aorimn/dislocker/archive/v0.7.1.tar.gz"
  sha256 "742fb5c1b3ff540368ced54c29eae8b488ae5a5fcaca092947e17c2d358a6762"
  revision 1

  bottle do
    sha256 "9c42e7c3d2cd45e53a81aa6d19c927dbc24a069daf31c159e2f5cf7c2faca775" => :high_sierra
    sha256 "d26f58de47cb27f00f16282bb6be058e90be87f83125468ba4b7ab6cc980a3e2" => :sierra
    sha256 "d3310d4ddd7ed225fd8f821448fa2edabd3956e637755498c0d7ee4b74ed4aa3" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "mbedtls"
  depends_on :osxfuse

  def install
    system "cmake", "-DCMAKE_DISABLE_FIND_PACKAGE_Ruby=TRUE", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/dislocker", "-h"
  end
end
