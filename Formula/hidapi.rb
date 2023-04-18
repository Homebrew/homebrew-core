class Hidapi < Formula
  desc "Library for communicating with USB and Bluetooth HID devices"
  homepage "https://github.com/libusb/hidapi"
  url "https://github.com/libusb/hidapi/archive/hidapi-0.13.1.tar.gz"
  sha256 "476a2c9a4dc7d1fc97dd223b84338dbea3809a84caea2dcd887d9778725490e3"
  license :cannot_represent
  head "https://github.com/libusb/hidapi.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5aea99e710bcf73d1fac8accd3e9a09b89371e01a4af2a82a24805a49dfb0a2b"
    sha256 cellar: :any,                 arm64_monterey: "bec6eb58d49ead05696b6161b5a6983d3db8ce3bee11f8ff84015553f7f67e79"
    sha256 cellar: :any,                 arm64_big_sur:  "8cfe0a3418efdc673f600642ff6f3a2e00da8b1a0dfd8ae69522d498313d3899"
    sha256 cellar: :any,                 ventura:        "c7e6be14f96decf0f3347679f8039ee6681159bee08b47b30d192d5bd201a1af"
    sha256 cellar: :any,                 monterey:       "78132127798d995319ef6d20380d380627af1510d5c4a0f42bca00a0f744c550"
    sha256 cellar: :any,                 big_sur:        "ac26c708492a75aeb308e29efc2631c0545aba947fef08fe51ebd16c416c5d8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b93d511f9c55afb290edc18e5c2c70662068940718c6990dada78bda990309a"
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
