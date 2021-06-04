class Dislocker < Formula
  desc "FUSE driver to read/write Windows' BitLocker-ed volumes"
  homepage "https://github.com/Aorimn/dislocker"
  url "https://github.com/Aorimn/dislocker/archive/v0.7.1.tar.gz"
  sha256 "742fb5c1b3ff540368ced54c29eae8b488ae5a5fcaca092947e17c2d358a6762"
  license "GPL-2.0"
  revision 5

  depends_on "cmake" => :build
  depends_on "mbedtls"

  on_macos do
    disable! date: "2021-04-08", because: "requires FUSE"
  end

  on_linux do
    depends_on "libfuse"
  end

  def install
    system "cmake", "-DCMAKE_DISABLE_FIND_PACKAGE_Ruby=TRUE", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/dislocker", "-h"
  end
end
