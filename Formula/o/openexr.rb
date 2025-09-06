class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "d7b31637d7adc359f5e5a7517ba918cb5997bc1a4ae7a808ec874cdf91da93c0"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c59a119799ced17fd5981d534348afb90dd0110e7934e2a2d79b3c948c59fea2"
    sha256 cellar: :any,                 arm64_sonoma:  "de0baf730922331986532b750a7226eeea2009c5dadabadba6520b8cd360438e"
    sha256 cellar: :any,                 arm64_ventura: "b6c8fdf23bb94f2f92cc48ac59a23b14d9610dbe6b3d78c509f96922088dbb4c"
    sha256 cellar: :any,                 sonoma:        "f9016ad319091e4e03c7321e6ab59653f0283a32ae838640f8c533f7261ea271"
    sha256 cellar: :any,                 ventura:       "4ecf0e6f600189b94b42a804d9611215e0b748c3a0a6661d1b77e1c6be20674b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a8af6ae4253bdf3859be5b2f9deae510d8ffe3448d3b6e92f47a56b4a7dd262"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d70159d15c712559ef5443867492f907626e2f8d44b3637cb7ddc2133e60b284"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "imath"
  depends_on "libdeflate"
  depends_on "openjph"

  uses_from_macos "zlib"

  # These used to be provided by `ilmbase`
  link_overwrite "include/OpenEXR"
  link_overwrite "lib/libIex.dylib"
  link_overwrite "lib/libIex.so"
  link_overwrite "lib/libIlmThread.dylib"
  link_overwrite "lib/libIlmThread.so"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-exr" do
      url "https://github.com/AcademySoftwareFoundation/openexr-images/raw/f17e353fbfcde3406fe02675f4d92aeae422a560/TestImages/AllHalfValues.exr"
      sha256 "eede573a0b59b79f21de15ee9d3b7649d58d8f2a8e7787ea34f192db3b3c84a4"
    end

    resource("homebrew-exr").stage do
      system bin/"exrheader", "AllHalfValues.exr"
    end
  end
end
