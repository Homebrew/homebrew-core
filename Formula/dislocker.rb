class Dislocker < Formula
  desc "FUSE driver to read/write Windows' BitLocker-ed volumes"
  homepage "https://github.com/Aorimn/dislocker"
  url "https://github.com/Aorimn/dislocker/archive/v0.7.1.tar.gz"
  sha256 "742fb5c1b3ff540368ced54c29eae8b488ae5a5fcaca092947e17c2d358a6762"
  revision 3

  bottle do
    sha256 "b3ea749c44b20b4b20a5a5e74079dd4c71b192db4e070f7d445b6a5eebdeadeb" => :mojave
    sha256 "9f591c911314d86b773311386f3ce327af3b9f01bb1d4539f07841380aa2249f" => :high_sierra
    sha256 "731f8224ccd50671c0b12795e3d95f5b96868d0d76373cc270c5d6fc1a86c6c4" => :sierra
    sha256 "c99aecc4388117f11cee11d6333137aea5a1359a229149b55200e06a2e836914" => :el_capitan
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
