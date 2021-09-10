class Hidapi < Formula
  desc "Library for communicating with USB and Bluetooth HID devices"
  homepage "https://github.com/libusb/hidapi"
  url "https://github.com/libusb/hidapi/archive/hidapi-0.10.1.tar.gz"
  sha256 "f71dd8a1f46979c17ee521bc2117573872bbf040f8a4750e492271fc141f2644"
  license :cannot_represent
  head "https://github.com/libusb/hidapi.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "b9a374fd0f191883bb75c4b881d24e569d547675d4cedbe3339c7aa6c3fe60b3"
    sha256 cellar: :any,                 big_sur:       "98f2859ea147e9c92e4925f0887062c8b6f5177eb98a1012b95d3b788cb58ea5"
    sha256 cellar: :any,                 catalina:      "9287809ecfeaeb3c89b1f9bf8babb31a8971b41c4a9795922ab774bfcc66559d"
    sha256 cellar: :any,                 mojave:        "e9c2bec30d5d1e9e0f9f91c43510071ba17234cd968b33f161c56cbee23a4d8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9973b200a49570955bd79accce1237d5751434f26ec17ace47580313dae882f"
  end

  # autoconf 2.70 fails with: configure.ac:16: error: AC_CONFIG_MACRO_DIR can only be used once
  # See https://github.com/libusb/hidapi/issues/264#issuecomment-830914402
  # Move to "autoconf" when updating to the next release
  depends_on "autoconf@2.69" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  on_linux do
    depends_on "libusb"
    depends_on "systemd" # for libudev
  end

  def install
    system "./bootstrap"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    # hidtest/.libs/hidtest does not exist for Linux, install it for macOS only
    bin.install "hidtest/.libs/hidtest" if OS.mac?
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
    on_macos do
      flags << "-lhidapi"
    end
    on_linux do
      flags << "-lhidapi-hidraw"
    end
    flags += ENV.cflags.to_s.split
    system ENV.cc, "-o", "test", "test.c", *flags
    system "./test"
  end
end
