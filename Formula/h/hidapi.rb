class Hidapi < Formula
  desc "Library for communicating with USB and Bluetooth HID devices"
  homepage "https://github.com/libusb/hidapi"
  url "https://github.com/libusb/hidapi/archive/refs/tags/hidapi-0.15.0.tar.gz"
  sha256 "5d84dec684c27b97b921d2f3b73218cb773cf4ea915caee317ac8fc73cef8136"
  license any_of: ["GPL-3.0-only", "BSD-3-Clause", "HIDAPI"]
  head "https://github.com/libusb/hidapi.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0839953f6566e9d44dcde4714cf3bb8fe8455eb8cf978bb5fb0fbfc595f5f16b"
    sha256 cellar: :any,                 arm64_sequoia: "7124104d00b05a26d69388fe5d451b8a9f684b01ed9a6ccea1c8265ba6586bfe"
    sha256 cellar: :any,                 arm64_sonoma:  "19e9592cabf7d3f5bd080c8ff3904afeceacbb0509b281ea4912e754854eaa26"
    sha256 cellar: :any,                 arm64_ventura: "95960cc384758cb3e3afb414718bb8ad02ace684bc5b103e7a5875071c36f062"
    sha256 cellar: :any,                 sonoma:        "a8e65cb302c9ddc9c44a2bcb2348ffb26be23e8d946261775acecc5a38b9ce7a"
    sha256 cellar: :any,                 ventura:       "7c3be7a7e5e21e5d84da1ed2f1fe86d0f47342f794583e12590f980b5a2004cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a42600180cd8daace07f984a2463a5d017b3548a911e0f659c8d036aa5e08e74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c532bf111617b2ccaf54649208d01aea0eaf4b53ba6b3270dee5455b4c9679bb"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "libusb"
    depends_on "systemd" # for libudev
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DHIDAPI_BUILD_HIDTEST=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "hidapi.h"
      int main(void)
      {
        return hid_exit();
      }
    C

    flags = ["-I#{include}/hidapi", "-L#{lib}"]
    flags << if OS.mac?
      "-lhidapi"
    else
      "-lhidapi-hidraw"
    end
    flags += ENV.cflags.to_s.split
    system ENV.cc, "-o", "test", "test.c", *flags
    system "./test"
  end
end
