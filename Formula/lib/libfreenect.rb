class Libfreenect < Formula
  desc "Drivers and libraries for the Xbox Kinect device"
  homepage "https://openkinect.org/"
  url "https://github.com/OpenKinect/libfreenect/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "adbfc6e7ce72f77cccb3341807a1e2cc6fe2ee62e1bc4d70a6c9b05fac83fe8f"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/OpenKinect/libfreenect.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fdd9e58ec7fee1c96b631972651db11b4386ccf9ac8e9ba54c41dd30a5df5102"
    sha256 cellar: :any,                 arm64_ventura:  "6b6e976f60aa61f7152f5718ef76de1c00f3b69f4c04367c9d4bae5f60172124"
    sha256 cellar: :any,                 arm64_monterey: "aa5115ad4e3fc18a5ad5756a546a9dbe500e4127682134f266fcc7a3c72c63f4"
    sha256 cellar: :any,                 arm64_big_sur:  "733424be170996321ea99ddbfabc0a395cb2d559e7e0b56255902a53cba6aa71"
    sha256 cellar: :any,                 sonoma:         "15bf180c0632a45c9ece9a114ba3b42d398acf8951683cef334ab0a0a497668c"
    sha256 cellar: :any,                 ventura:        "952fcc1af45af220088b79af7ac99d351b0beb490e0a9cc2ff4a42887922a457"
    sha256 cellar: :any,                 monterey:       "950df9d8e8b39b312b12028b8e95fa8af11cbc2b94a538a5e8be74acd5901f51"
    sha256 cellar: :any,                 big_sur:        "97f55a7543778c5e8e09cc1b4ecd928b0c54016323fbc104813b7393efad40e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d651605c3afdbff1aee2405b162509bd8754d2fbf4246ece112574fd5be8de77"
  end

  depends_on "cmake" => :build
  depends_on "libusb"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                      "-DBUILD_OPENNI2_DRIVER=ON"
      system "make", "install"
    end
  end

  test do
    system bin/"fakenect-record", "-h"
  end
end
