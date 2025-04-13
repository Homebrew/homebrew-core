class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v3.3.3.tar.gz"
  sha256 "0ffbd842a7ee2128d44affdea30f42294b4061293cde3aa75b61a53573413d1e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "095b03c2de45fa33ca35a42af614570d627a9a804dc99dc1c207b4687437c4b6"
    sha256 cellar: :any,                 arm64_sonoma:  "120c5a42eb3a3ef8f77336da362cd413fdb0d1a5d2afb9057ad141e55995a9bd"
    sha256 cellar: :any,                 arm64_ventura: "ce83bbf9a04d07873a41f9232740e20890da994b9fa38b524346929f98e7ed9d"
    sha256 cellar: :any,                 sonoma:        "c3fce261a7a0b29e32312f5fd2d539ef6e50984dbaf479439e5ca894e8827fa8"
    sha256 cellar: :any,                 ventura:       "e425a3e4a316cdb3c325e7baf1c196c66d9e76c0728b557903201841f711617d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c12a57a4b9226facb0e536f7a181600ce8594168c2652d06adae51b18ee6fcf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "862cc7b4a884fd67c2cc91e695d5b01a5a35f4216222a1d33f93f24e5c45836a"
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
