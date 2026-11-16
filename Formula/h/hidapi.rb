class Hidapi < Formula
  desc "Library for communicating with USB and Bluetooth HID devices"
  homepage "https://libusb.info/hidapi/"
  url "https://github.com/libusb/hidapi/archive/refs/tags/hidapi-0.16.0.tar.gz"
  sha256 "bc599d295792fe515778f19ce86a49760b0ea5fc114e5258245d470609632bbf"
  license any_of: ["GPL-3.0-only", "BSD-3-Clause", "HIDAPI"]
  compatibility_version 1
  head "https://github.com/libusb/hidapi.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "adf377bac31b67f0b3aad40d7567610ba159ae6e4b503c09232f78683a4de2df"
    sha256 cellar: :any, arm64_tahoe:       "44f19f17ac637c9ff3e24fd442205c674ec8f5fcf9f7a06e0135e2091a1bc367"
    sha256 cellar: :any, arm64_sequoia:     "fbfed806633cd2477bdd6055b7306fbcbf84227a0bccb35cdec4017889371fee"
    sha256 cellar: :any, arm64_linux:       "2c86ebca0eab2dc5ad6693b4b5e4e02cb82add3743b983443f828e29766fedf4"
    sha256 cellar: :any, x86_64_linux:      "0a5dd57fe4d72a980f17a65aede0b623cb8cd1eba64f2a503b060c572227729d"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "libusb"
    depends_on "systemd" # for libudev
  end

  deny_network_access!

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
