class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  # NOTE: Please keep these values in sync with imath.rb when updating.
  url "https://github.com/openexr/openexr/archive/v3.1.3.tar.gz"
  sha256 "6f70a624d1321319d8269a911c4032f24950cde52e76f46e9ecbebfcb762f28c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "cb2251482943ccba760aaad07eb478778883261426c0b3e9a59781ab0ec93011"
    sha256 cellar: :any,                 arm64_big_sur:  "6b2bb42d4a828b364c664883e49680d6867aa76071c87d4e3f71fa43ce295203"
    sha256 cellar: :any,                 monterey:       "51a90b139c9c9e62267c1d91653e71ff5483017d3137b27f2bd50a095c29b2b6"
    sha256 cellar: :any,                 big_sur:        "d48e166e020597151ad259fc62f321ec128777dc6353e951dee014929b47dda4"
    sha256 cellar: :any,                 catalina:       "6c43a1e10c1def8c49cc63b4cd50c705be7187ecc7d309309d555104ad886c92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08dee6134b6115466678e17b91da4e450891b4f0534d3438065594fecdc0dd62"
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

  resource "exr" do
    url "https://github.com/openexr/openexr-images/raw/master/TestImages/AllHalfValues.exr"
    sha256 "eede573a0b59b79f21de15ee9d3b7649d58d8f2a8e7787ea34f192db3b3c84a4"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    resource("exr").stage do
      system bin/"exrheader", "AllHalfValues.exr"
    end
  end
end
