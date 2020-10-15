class Dislocker < Formula
  desc "FUSE driver to read/write Windows' BitLocker-ed volumes"
  homepage "https://github.com/Aorimn/dislocker"
  url "https://github.com/Aorimn/dislocker/archive/v0.7.1.tar.gz"
  sha256 "742fb5c1b3ff540368ced54c29eae8b488ae5a5fcaca092947e17c2d358a6762"
  license "GPL-2.0"
  revision 4

  bottle do
    sha256 "e0049b9ff51ad9f3e4008df1edac9b52aa0d8df55e119990553b4d9cec651b90" => :catalina
    sha256 "f6378852886b1d1793260ce411250751614428102a5fd07f792352ce0fc206c3" => :mojave
    sha256 "2b1e50229eb344c432db6cc35fd42b6e91d713f97f81d6f5067087f5c59b6cb3" => :high_sierra
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
