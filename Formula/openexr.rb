class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://github.com/openexr/openexr/archive/v2.5.3.tar.gz"
  sha256 "6a6525e6e3907715c6a55887716d7e42d09b54d2457323fcee35a0376960bebf"
  license "BSD-3-Clause"

  bottle do
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
