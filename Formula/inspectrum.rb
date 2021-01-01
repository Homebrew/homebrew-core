class Inspectrum < Formula
  desc "Offline radio signal analyser"
  homepage "https://github.com/miek/inspectrum"
  url "https://github.com/miek/inspectrum/archive/v0.2.3.tar.gz"
  sha256 "7be5be96f50b0cea5b3dd647f06cc00adfa805a395484aa2ab84cf3e49b7227b"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/miek/inspectrum.git"

  bottle do
    cellar :any
    sha256 "b2ccb3e2e45373c9aa03388d0ae6c90c15cc3261fb4c014d98f509861e8afab4" => :big_sur
    sha256 "f7eae4a492478910e123b6515657bf7db836044a3b976634a89f697cb9cabcfb" => :arm64_big_sur
    sha256 "637f4276c9515232a3784b162fd21d3de9fcfd53cef12010e7cd7b3aba78f1c6" => :catalina
    sha256 "86cc47bb1267acc1e202cbd6eb5845750225bbb0d7a5dc3ae5058a58d7be6765" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "liquid-dsp"
  depends_on "qt"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match "-r, --rate <Hz>     Set sample rate.", shell_output("#{bin}/inspectrum -h").strip
  end
end
