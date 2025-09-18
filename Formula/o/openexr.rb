class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "d7b31637d7adc359f5e5a7517ba918cb5997bc1a4ae7a808ec874cdf91da93c0"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3b8399fc525775833f8fba8d87e1f826395821fb89e731d6300637fb225e20f7"
    sha256 cellar: :any,                 arm64_sequoia: "c4c825d0859bc9cc9bf6086e69c25caffca882ef6c41f69913a796b650ece152"
    sha256 cellar: :any,                 arm64_sonoma:  "e928cc92ecd460cec89f38e48b2060b4dbf5c6bc0bdcea88a88a1dfb1e46d344"
    sha256 cellar: :any,                 arm64_ventura: "9ba599ee84193cd7e369deb04d5105caa7759d7b0130f329800ba88af73e70b2"
    sha256 cellar: :any,                 sonoma:        "dd7af49befb4bd0a262e06e839d7bc01a7fb854cfeab0e91abc53985161c8f9b"
    sha256 cellar: :any,                 ventura:       "3f968e598539290d5faef73e9109a975350909d11f14b543ebb3e9dda7e78589"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4484104eaaeccf2aa2742c49a0abae0f8acfc57b9ec31731dbee921897a4ebd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec8112e2e852862bd18e1111d6b17e9a6e74e3a140052f5365cada1ea52b5f8d"
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
    # Workaround with `openjph` >= 0.23 that doesn't include the prefix for cmake files
    inreplace "src/lib/OpenEXRCore/internal_ht.cpp", "<ojph_", "<openjph/ojph_"

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
