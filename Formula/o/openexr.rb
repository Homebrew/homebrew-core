class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/openexr/archive/v3.2.0.tar.gz"
  sha256 "b1b200606640547fceff0d3ebe01ac05c4a7ae2a131be7e9b3e5b9f491ef35b3"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f3ea42ae19e899dd825a2ebd0642893ebc11a425c242933d7fa51a0e0f5065d9"
    sha256 cellar: :any,                 arm64_ventura:  "208ccfd4f30fbd23693d26f347293f256770ce4d67d988654b336da312b402f7"
    sha256 cellar: :any,                 arm64_monterey: "7cc1fbca357a40573148e147101d5146fc4f9eca8934d78fc87818c61cbbc94e"
    sha256 cellar: :any,                 arm64_big_sur:  "77064bffa6b3ff7cb5a54beb78d04c3ac481c260bc74ef2ecd1c01a9bde2599d"
    sha256 cellar: :any,                 sonoma:         "932487c8e2af63b9407dd5cccdf325ddf27e7512ab06c338651deba7e1957f48"
    sha256 cellar: :any,                 ventura:        "00d31d83f9225fbf00562611e87b7b6a3522066964184e06a6c368b9e6783469"
    sha256 cellar: :any,                 monterey:       "6882a699b3405b4d1e00b50e313fc1fcad33a4906c4a2934c7842e0d4e1437c1"
    sha256 cellar: :any,                 big_sur:        "edeb3ea6b57380f9272b4ebba6f9f649ec281e6febf4c66de073cdc197f889b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "423a213f950fe3befd5287f0e26922310f244e9e927ab9c6ad3853beae7daba4"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "imath"

  uses_from_macos "zlib"

  # These used to be provided by `ilmbase`
  link_overwrite "include/OpenEXR"
  link_overwrite "lib/libIex.dylib"
  link_overwrite "lib/libIex.so"
  link_overwrite "lib/libIlmThread.dylib"
  link_overwrite "lib/libIlmThread.so"

  resource "homebrew-exr" do
    url "https://github.com/AcademySoftwareFoundation/openexr-images/raw/f17e353fbfcde3406fe02675f4d92aeae422a560/TestImages/AllHalfValues.exr"
    sha256 "eede573a0b59b79f21de15ee9d3b7649d58d8f2a8e7787ea34f192db3b3c84a4"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    resource("homebrew-exr").stage do
      system bin/"exrheader", "AllHalfValues.exr"
    end
  end
end
