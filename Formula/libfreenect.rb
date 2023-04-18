class Libfreenect < Formula
  desc "Drivers and libraries for the Xbox Kinect device"
  homepage "https://openkinect.org/"
  url "https://github.com/OpenKinect/libfreenect/archive/v0.6.4.tar.gz"
  sha256 "6169600f999729a7f99dd71a9825ed6e7aec8b8aac4f532ecf2911f76133c125"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/OpenKinect/libfreenect.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "eeaefea3c833809024c643dd444bd588be4045c77af898aa2520c5b457429d87"
    sha256 cellar: :any,                 arm64_monterey: "7051953ec9958dfe54c2f65edc97e18e2df9bd43d545b977e95dd73ec553f8a5"
    sha256 cellar: :any,                 arm64_big_sur:  "2129c9a0986cb332fdea26e6e7094d68e377aea898493c8d3e37534118a1a94f"
    sha256 cellar: :any,                 ventura:        "08461a257c1337cfd37a2ac53b46f24ef8ac5ce9efa19c93ffe2fdd494409439"
    sha256 cellar: :any,                 monterey:       "281860b157bd771e268f823c1c21a5a620942314bbad9850a235a5c9610f30bb"
    sha256 cellar: :any,                 big_sur:        "fb1dcb243ce31b970b5c18c1651a051f284c58a77693a21e62f857e87bf063d2"
    sha256 cellar: :any,                 catalina:       "6a45ea2a3d5a89af85e3dc68cae2d77a4705d3607839c7e8ea41850f6cbe3740"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d036fdf727eeecbb1529529dfe013a4f036667f76732e5df21e883ce9ff29c53"
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
