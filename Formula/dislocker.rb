class Dislocker < Formula
  desc "FUSE driver to read/write Windows' BitLocker-ed volumes"
  homepage "https://github.com/Aorimn/dislocker"
  url "https://github.com/Aorimn/dislocker/archive/v0.7.1.tar.gz"
  sha256 "742fb5c1b3ff540368ced54c29eae8b488ae5a5fcaca092947e17c2d358a6762"

  bottle do
    sha256 "1b1fede1c17fb9829555c1ec85ea883a4b1fe7ae13f6ba595ec5504a06949f87" => :high_sierra
    sha256 "68728e2f7ba2aae2b25fa4ef51596e62294bb1ca2b73f4def09b955dc5648f29" => :sierra
    sha256 "fc7988168917b9635fb81cf1411aaaeec893e25a1be7e2bdefe40a6e80747c0a" => :el_capitan
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
