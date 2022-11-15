class Hidapi < Formula
  desc "Library for communicating with USB and Bluetooth HID devices"
  homepage "https://github.com/libusb/hidapi"
  url "https://github.com/libusb/hidapi/archive/hidapi-0.12.0.tar.gz"
  sha256 "28ec1451f0527ad40c1a4c92547966ffef96813528c8b184a665f03ecbb508bc"
  license :cannot_represent
  head "https://github.com/libusb/hidapi.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "da52f714c620a873dfc84bc760aa2be3c4e5a9c611e3ca6e8cc69cde7e0b5213"
    sha256 cellar: :any,                 arm64_monterey: "aa1f68edd1eee2d600109484c6f284374a4dd3275004171eaa819c1c6ff8e67d"
    sha256 cellar: :any,                 arm64_big_sur:  "8abecf0b9d8a3ce86a4313f3feb33d3a5eae2b8db580c0aa084cae9878400ba4"
    sha256 cellar: :any,                 ventura:        "344f250857a9b2d2356923ad70848f82be247f245bc1457a86d48efc4fffe140"
    sha256 cellar: :any,                 monterey:       "becf77159ab020fd2a66cf3e1f0489c95d8020b93b3c48fc095d2b8d0245336a"
    sha256 cellar: :any,                 big_sur:        "ba016a5a9004eb00fb1c037f9b6db103de6d27f9cae7139fb22f62c668eb9b90"
    sha256 cellar: :any,                 catalina:       "607766ce3cef88e33a8674b3c7cf69cdbe6124845c7ff223e07cceb2ec74df29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "828e2c72ca7e6903a9e3b7ddc0e66765eee1df977a6e832b2c66965cb4571f26"
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
