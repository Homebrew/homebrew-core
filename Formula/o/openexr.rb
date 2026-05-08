class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v3.4.11.tar.gz"
  sha256 "63730442f5fd6c5a79395bdd199040ab3821c229066049f52a57424a984b16ed"
  license "BSD-3-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "63bcb730ea313e760b643a1c9839135048161714893c2344ebb65b7ef4ba5326"
    sha256 cellar: :any,                 arm64_sequoia: "64d6633b39273461679a0935c824219bf510b46a6f6711693093d085fd4d316c"
    sha256 cellar: :any,                 arm64_sonoma:  "1184e505d08d8e02e35dcb05234a928e198a690ee5636c705ab02e71564f4e80"
    sha256 cellar: :any,                 sonoma:        "8fc5fbc0779e15900a3b0558a7d04fa0259b56ceace654b39689f745876a6149"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b62721400c1e883fe44de305501244f7cef867ba85002c8eb615cdb39be975f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2de13951cd0f532a19d8d85b00162fc1e59740118a1435f4c4eeab84dda7d098"
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
