class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  # NOTE: Please keep these values in sync with ilmbase.rb when updating.
  url "https://github.com/openexr/openexr/archive/v2.5.4.tar.gz"
  sha256 "dba19e9c6720c6f64fbc8b9d1867eaa75da6438109b941eefdc75ed141b6576d"
  license "BSD-3-Clause"

  bottle do
    sha256 "eb633be8c992dbfa2bb4406cd397abfe16aad0bf75f252e02e8ff7d720a9f93c" => :big_sur
    sha256 "f23f4e7523ae27fbc1885360cc99dc60b35cca395b6f8f46d45c1d7c275f0e90" => :arm64_big_sur
    sha256 "8f146ff213eda72a32613ba36649a865848786c0e843fc6a39e58bdeafebcb31" => :catalina
    sha256 "b9f0b513b60da938425fd93805835cfaaa916db9406687a7aa11112ec152a6f7" => :mojave
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
