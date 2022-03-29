class Hidapi < Formula
  desc "Library for communicating with USB and Bluetooth HID devices"
  homepage "https://github.com/libusb/hidapi"
  url "https://github.com/libusb/hidapi/archive/hidapi-0.11.2.tar.gz"
  sha256 "bc4ac0f32a6b21ef96258a7554c116152e2272dacdec1e4620fc44abeea50c27"
  license :cannot_represent
  head "https://github.com/libusb/hidapi.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4cd8bf68cf8c54942370bb114b3928e441e30da526463f119bffc987a736511e"
    sha256 cellar: :any,                 arm64_big_sur:  "636354e15d0e76384481a9b693ea08a6343316a7e1d74900cfa5add652aac2e5"
    sha256 cellar: :any,                 monterey:       "087066a1847dcf7a1b226db08e38905f130ff497b91db3ea59c10b4eeada56c4"
    sha256 cellar: :any,                 big_sur:        "9791b3c4132542c1f847b152c4cc3766842db3514df87ee1d30dc03e190e98b5"
    sha256 cellar: :any,                 catalina:       "7c6ed494c8c276acdea0198a5ae608144d4e12ce25c90af75bd96c31c2abc1fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b78d9953e9d63014391c67f20a2ef48e7d2d7b054cd660b8bef6bf014c0d80a0"
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
