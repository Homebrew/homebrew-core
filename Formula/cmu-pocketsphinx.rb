class CmuPocketsphinx < Formula
  desc "Lightweight speech recognition engine for mobile devices"
  homepage "https://cmusphinx.github.io/"
  url "https://github.com/cmusphinx/pocketsphinx/archive/v5.0.0.tar.gz"
  sha256 "78ffe5b60b6981b08667435dd26c5a179b612b8ca372bd9c23c896a8b2239a20"
  license "BSD-2-Clause"
  head "https://github.com/cmusphinx/pocketsphinx.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "0061941ed90615f083e805696e01ae0533e841cb0898efe8ed0170fe2f55b5a6"
    sha256 arm64_monterey: "14914963bdeccfbb391f4a9c6e5fde36e7aceb9042592b70a3e11406a553d55b"
    sha256 arm64_big_sur:  "0c8d323fbae3061aedc96f195ac9eb22b8cabc9b14b3f3ff2afbf327442a2050"
    sha256 ventura:        "7e44c0fc71cf5cb8794dfd900492af1ae1e0ab2b3db8b1d261293b3b22c27964"
    sha256 monterey:       "6db158c91df59ec2d1545c5e31d0b0e297c4955e651fd963c1c4d70d8a3f88d2"
    sha256 big_sur:        "f5784b0c53d002bde02fe0e2c09a4c0c305fb6216a6eeaa57b1914ec94e7bdf8"
    sha256 x86_64_linux:   "d85571c34ac30744302170922e466c101cd7a6c8d8bf7cbccc5941cd416a2a83"
  end

  depends_on "cmake" => :build

  # Fix header installation. Can be removed in next release after 5.0.0.
  patch do
    url "https://github.com/cmusphinx/pocketsphinx/commit/74a5ec86468a481cae2a6167a0921455354232d3.patch?full_index=1"
    sha256 "ef9ad6edbba721cc3e4fe0cf9ba0dd14ed18b9f4cb4be079e021f0e28221160a"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build"
    system "cmake", "--build", "build", "--target", "install"
  end
end
