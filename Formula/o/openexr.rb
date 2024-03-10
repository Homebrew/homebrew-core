class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v3.2.3.tar.gz"
  sha256 "f3f6c4165694d5c09e478a791eae69847cadb1333a2948ca222aa09f145eba63"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a357d90dc61aa4a52341360d4f0c00380d92efe60b1bbf8d3414cd9cc4fd9313"
    sha256 cellar: :any,                 arm64_ventura:  "791d76391dccefe54ff1a26920a256ebdee3e83d3bcfb7d94bd5b60f57237a05"
    sha256 cellar: :any,                 arm64_monterey: "58a60da9dcce71915ce5dc11b4330d09c712f6040740f9bffc26efecbbb5d7c7"
    sha256 cellar: :any,                 sonoma:         "03d8be45f4df92a8a4686fc40b53ad53b9b56827606d21d9df56a320e65f86fb"
    sha256 cellar: :any,                 ventura:        "a44dc65bf9d528bf238da62658821d4b8a38fe78102e1138feabc4cb5c024f1f"
    sha256 cellar: :any,                 monterey:       "551c9b7829489ffe3e6334b1c7a7a38ba4cf75d8ca2a1560b3936f81491e4e0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0618d89a16c7644fb231d68b3fe5b131bac75278d5050921abadaed771f610c"
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
