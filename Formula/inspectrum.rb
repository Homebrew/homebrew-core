class Inspectrum < Formula
  desc "Offline radio signal analyser"
  homepage "https://github.com/miek/inspectrum"
  url "https://github.com/miek/inspectrum/archive/v0.1.1.tar.gz"
  sha256 "b139cd7978f294d4872a1e3e70a813f4e9600f7677da5b9f6c431b3fa7f7e03e"

  depends_on "qt5"
  depends_on "fftw"
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "liquid-dsp"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "inspectrum -h"
  end
end
