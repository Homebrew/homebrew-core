class Hidapi < Formula
  desc "Library for communicating with USB and Bluetooth HID devices"
  homepage "https://github.com/libusb/hidapi"
  url "https://github.com/libusb/hidapi/archive/hidapi-0.13.1.tar.gz"
  sha256 "476a2c9a4dc7d1fc97dd223b84338dbea3809a84caea2dcd887d9778725490e3"
  license :cannot_represent
  head "https://github.com/libusb/hidapi.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8283cc1399ff7f715b378fc9113264e9ca61d91fa6d34b9ef4be52b2ee2c8ea0"
    sha256 cellar: :any,                 arm64_monterey: "1d85457938ef4e796da48cf82edf6b3c35617c67001a1941da91fc8009372b57"
    sha256 cellar: :any,                 arm64_big_sur:  "24556678b9bde693b7f502ac8a6c7faa1416feb7b065c950a43ae161d672570b"
    sha256 cellar: :any,                 ventura:        "624a748fad0354e63ce07971d20287fab76b63ca749781ad25fa60ddb1a048f9"
    sha256 cellar: :any,                 monterey:       "aac278e685220cf11824223b8f501523bb34d568e69ba0755ac9b18d774b2cb4"
    sha256 cellar: :any,                 big_sur:        "1e105aa66cf9af4678883a0ecced3c600fce6fe30152849ce2bf79eaa14460dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccaf4f241b7d8ced04faf9e9b0926f47fc459fbf4dd1838958b1087900bc136b"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  on_linux do
    depends_on "libusb"
    depends_on "systemd" # for libudev
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DHIDAPI_BUILD_HIDTEST=ON"
      system "make", "install"

      # hidtest/.libs/hidtest does not exist for Linux, install it for macOS only
      bin.install "hidtest/hidtest" if OS.mac?
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "hidapi.h"
      int main(void)
      {
        return hid_exit();
      }
    EOS

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
