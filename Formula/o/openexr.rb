class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v3.3.2.tar.gz"
  sha256 "5013e964de7399bff1dd328cbf65d239a989a7be53255092fa10b85a8715744d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "15c440ea45fe300c8756c9013538b86d946ed456f425c01afafb33ff1a8da7d5"
    sha256 cellar: :any,                 arm64_sonoma:  "0fe7eadd18353953998350145a571f9345785dd13d4f7a6b68d4ac76b5981732"
    sha256 cellar: :any,                 arm64_ventura: "af8d8617924061ea03870e15c819d6517d7af6560eb4636b99bdd30c34eb96e2"
    sha256 cellar: :any,                 sonoma:        "94a0453a5ec9b940438dd111a56e762275915851d61ea5d5eb43e510172b1e08"
    sha256 cellar: :any,                 ventura:       "575cdfa90c04906376aa9083f75f0405c38ffb5b033164f140244a3e572d854d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "544108614f9156fde192de0bb340669a48a175b1d1c8e4a549b7ea14011f59c7"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "imath"
  depends_on "libdeflate"

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
