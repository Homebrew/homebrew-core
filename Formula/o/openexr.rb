class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v3.5.2.tar.gz"
  sha256 "85a291b9b8563fabef1aa3f6e912d744ce1d4b9fd5a8f978eda194cd51b15ae9"
  license "BSD-3-Clause"
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5253d81b12415e20841324740f399f92d070e09e75421ba914385e0374973620"
    sha256 cellar: :any, arm64_tahoe:       "5b6d293d0f7d3b4b8b8aba409f86ff3824b62ac5e4f0b57951158ab0ae98a937"
    sha256 cellar: :any, arm64_sequoia:     "20e7c998ed534e281f8606b1567b047ceedb0e19272bf0545ae2128d8c589488"
    sha256 cellar: :any, arm64_linux:       "a26985be817fe6e606ece9e3fcec6474946199a7f8d680ef8fcf8a493399cdf5"
    sha256 cellar: :any, x86_64_linux:      "5a998e444c48037ae9c9a5e0a3b87a2cb7132f6820b5167a83534c65485c98e9"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "imath"
  depends_on "libdeflate"
  depends_on "openjph"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # These used to be provided by `ilmbase`
  link_overwrite "include/OpenEXR"
  link_overwrite "lib/libIex.dylib"
  link_overwrite "lib/libIex.so"
  link_overwrite "lib/libIlmThread.dylib"
  link_overwrite "lib/libIlmThread.so"

  resource "homebrew-exr", :test do
    url "https://github.com/AcademySoftwareFoundation/openexr-images/raw/f17e353fbfcde3406fe02675f4d92aeae422a560/TestImages/AllHalfValues.exr"
    sha256 "eede573a0b59b79f21de15ee9d3b7649d58d8f2a8e7787ea34f192db3b3c84a4"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource("homebrew-exr").stage do
      system bin/"exrheader", "AllHalfValues.exr"
    end
  end
end
