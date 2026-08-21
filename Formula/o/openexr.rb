class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v3.4.14.tar.gz"
  sha256 "13c3327100a7b92e4c6a048db03ef07ee2db8e79baa4c517c6fae71e5b80034b"
  license "BSD-3-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4ff156dafb0a897430b0b4cc5b3b5dfb7982631be4a39cf86b4f469acfc2b8de"
    sha256 cellar: :any, arm64_sequoia: "04275214bad2caa7a1851a9e7880db9d4be2afb5acc3af5d21feb777889a8705"
    sha256 cellar: :any, arm64_sonoma:  "b1fb0c788e4c66aed5cc29affc194a4d943e43eaf2dd544d7ad06172ac289703"
    sha256 cellar: :any, sonoma:        "97c7de11cd15128b5e45451134e439edeb75dc3ea62a15908b98bcf8ab9545a7"
    sha256 cellar: :any, arm64_linux:   "f48b2bfd40d9ea710a7e89688a7d6e776a90a60dd4a6888313052e47c65071cb"
    sha256 cellar: :any, x86_64_linux:  "f13041c4231350f0a28a2314d7c68d8a1d68ed3ffbcfa178564fa6933fd51e53"
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
