class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v3.4.4.tar.gz"
  sha256 "7c663c3c41da9354b5af277bc2fd1d2360788050b4e0751a32bcd50e8abaef8f"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "65cb3c318b1f61e78562689de8068799092473dc9967a433c7513507b4e3e762"
    sha256 cellar: :any,                 arm64_sequoia: "2c9b82a02381d023df9913f2d8930e276869b989858803fa5231035459642d94"
    sha256 cellar: :any,                 arm64_sonoma:  "42de5681c202c46b293958daf4b59292c398edf98e6eb7233627f4ce6dd435fc"
    sha256 cellar: :any,                 sonoma:        "0569bee2053e22dcc57643ef51a1a5b6109c30c1fde69f5281ed6c5c5ed5d0fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56842c457c8fd20c917b53898aeea29e777ae56d072c6b47b77a137b5f798b3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5890b0d036b79cb4e1c2f875e15ca43a62948c87f3d6403d4b3339ed831f8606"
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
