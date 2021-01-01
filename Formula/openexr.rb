class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  # NOTE: Please keep these values in sync with ilmbase.rb when updating.
  url "https://github.com/openexr/openexr/archive/v2.5.4.tar.gz"
  sha256 "dba19e9c6720c6f64fbc8b9d1867eaa75da6438109b941eefdc75ed141b6576d"
  license "BSD-3-Clause"

  bottle do
    sha256 "32281289a0172057d12178a4d267e6facb04b27d03f9ab7dad3248e200592d33" => :big_sur
    sha256 "63ee4ba9425d86bd56b377717dc97a8ca13d7f38cd13ac65e744cce521800f1d" => :arm64_big_sur
    sha256 "7ab2025ad66f69797e93c0e912860a828acdd244fa231358c9edd49105aa852b" => :catalina
    sha256 "56cb6dd7c7bf57642ca718308a438d512c3064475b5286343838e1218820b3b7" => :mojave
    sha256 "e2aba00b452411237f263b8dda16cff59fc82ece2a0b8e2f93166f902886348a" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ilmbase"

  uses_from_macos "zlib"

  resource "exr" do
    url "https://github.com/openexr/openexr-images/raw/master/TestImages/AllHalfValues.exr"
    sha256 "eede573a0b59b79f21de15ee9d3b7649d58d8f2a8e7787ea34f192db3b3c84a4"
  end

  def install
    cd "OpenEXR" do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    resource("exr").stage do
      system bin/"exrheader", "AllHalfValues.exr"
    end
  end
end
