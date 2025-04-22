class Hidapi < Formula
  desc "Library for communicating with USB and Bluetooth HID devices"
  homepage "https://github.com/libusb/hidapi"
  url "https://github.com/libusb/hidapi/archive/refs/tags/hidapi-0.14.0.tar.gz"
  sha256 "a5714234abe6e1f53647dd8cba7d69f65f71c558b7896ed218864ffcf405bcbd"
  license any_of: ["GPL-3.0-only", "BSD-3-Clause", "HIDAPI"]
  head "https://github.com/libusb/hidapi.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "ed4edcb94c18b6f2dfe35b9642a92bfb9198258e7c195d5100b1f84d7e9c0f41"
    sha256 cellar: :any,                 arm64_sonoma:   "8f665c92f1b3012852243abfc40b427cba3d4e581070cd4f2d8fa5dd185dd4d5"
    sha256 cellar: :any,                 arm64_ventura:  "a51ee174536f9f73d398c2b6a998df28c812a5baac14e4f07e8bb17c846d53cf"
    sha256 cellar: :any,                 arm64_monterey: "4330e0a273dcb943f27e2be002fad07c385737bd308478b73bf24be2898c9bf5"
    sha256 cellar: :any,                 arm64_big_sur:  "18184e80f9d6ce6e702068b67d4e887dbb28d3fb753c379b6e97c6fbed3cdf97"
    sha256 cellar: :any,                 sonoma:         "3250f61ca23b7654de19d272869f70b15b9227dcdf449610b44af13286d32dc6"
    sha256 cellar: :any,                 ventura:        "7198e6d7a9946aa995eee2dcb7595dddb362aa5ed3ed5bcc7b3eeb08fb5cb9e4"
    sha256 cellar: :any,                 monterey:       "94a5ead30ea58235a8e1cfe884f55c10756efdd580954e1b0565f2298f9f0376"
    sha256 cellar: :any,                 big_sur:        "7c131edf18d63b5cc8844cda43f8347808a5fd4668739b577c2d1a72f779df4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "41a1f24c942d2481bb0ffa64c68ba664be5eb45108a21019925e8688b0bbc6df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8c0fe481208e93135393bb11e970917dd10438ccfdbc180bc5efb97aec7ce52"
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
