class Dislocker < Formula
  desc "FUSE driver to read/write Windows' BitLocker-ed volumes"
  homepage "https://github.com/Aorimn/dislocker"
  url "https://github.com/Aorimn/dislocker/archive/v0.7.1.tar.gz"
  sha256 "742fb5c1b3ff540368ced54c29eae8b488ae5a5fcaca092947e17c2d358a6762"
  revision 3

  bottle do
    sha256 "46b035d19f6018459fa992f3eb545894db765efa4052061e85ead0068ca22494" => :high_sierra
    sha256 "ab72efdaa32b089c1c9d6de8aedb64cabfc192499a6351ad13f6243fbe57b636" => :sierra
    sha256 "64e58efdec222c81610466d045104bca4509a40970f39bb0e3238ce7ef4c4c4d" => :el_capitan
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
