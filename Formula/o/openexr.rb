class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "d7b31637d7adc359f5e5a7517ba918cb5997bc1a4ae7a808ec874cdf91da93c0"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "04393e92e8b7516b7bac837c4d6083e549333aa2a1cac42d5641cdd853b0778f"
    sha256 cellar: :any,                 arm64_sequoia: "8c79277fc1662e8699332d4560a07fbf46340c9e273a05457a9fa39663d098bf"
    sha256 cellar: :any,                 arm64_sonoma:  "c0f2d4b8b92b4c496eded2a1c167f474a77d2cc37366a0fa044d7a02d871101b"
    sha256 cellar: :any,                 sonoma:        "9d8f92e1a24307fde039a7da38a1155638edc96e1bc65254dfccd26a9fcd5839"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c16f6b42676781d2a7f8ee8a85fe33ea660d088130305fc06e5977a7ab53b48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfa7a34d3cd993943fd62a73241ad0a0670b93371380a9f2dea7599b0fa46e84"
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
