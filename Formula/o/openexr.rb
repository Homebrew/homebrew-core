class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v3.4.10.tar.gz"
  sha256 "b61ae2d0fa4872c5f5fc45618f107945df37c0eba4853263091b949c513d3319"
  license "BSD-3-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "623ae02f5db193d2812ecd8d2cebeec4c11854ffeb2231cce90010377fc060f4"
    sha256 cellar: :any,                 arm64_sequoia: "09ab9a6fa80ba14e82c992d56a15070c19ea8d23e9cf8f6e6ed5a22a39778cd8"
    sha256 cellar: :any,                 arm64_sonoma:  "4ae91b9cdc38374b4ecd80ce0def49e80f7a6c351560aeff3bc9f46f22d6b3cb"
    sha256 cellar: :any,                 sonoma:        "ec96db2b6595dd967923fbb8d2e4dd16fdd365e6264f2705555803000dfc67fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6dd8f6c747c7416958c7df9829e081d3a8f04c6a5fb40ff5df8899db573cd34b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f07d1fccfdf54ce2dfb458bc8dc4e76a0d7ef31ac7b86a13f7cbd5e2b7928ef9"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "imath"
  depends_on "libdeflate"
  depends_on "openjph"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
