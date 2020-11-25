class Hidapi < Formula
  desc "Library for communicating with USB and Bluetooth HID devices"
  homepage "https://github.com/libusb/hidapi"
  url "https://github.com/libusb/hidapi/archive/hidapi-0.10.1.tar.gz"
  sha256 "f71dd8a1f46979c17ee521bc2117573872bbf040f8a4750e492271fc141f2644"
  license :cannot_represent
  head "https://github.com/libusb/hidapi.git"

  bottle do
    cellar :any
    sha256 "eefba549787906747456fddfed47c306b3c5157db9da0926e919aba420166e3b" => :big_sur
    sha256 "72dfa16cd42bbd13962305d59632f144110c647dd575407fedf4596e18bd1ddb" => :catalina
    sha256 "71d043045302a15cdb18ec3180f798dda312ee5a0f56ea269c5aabfc67c8119d" => :mojave
    sha256 "0b5108af3c48a0d208b74f7f970dd73cda8d5b9dd6e7baed7424efc439bca8bf" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "./bootstrap"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    bin.install "hidtest/.libs/hidtest"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "hidapi.h"
      int main(void)
      {
        return hid_exit();
      }
    EOS

    flags = ["-I#{include}/hidapi", "-L#{lib}", "-lhidapi"] + ENV.cflags.to_s.split
    system ENV.cc, "-o", "test", "test.c", *flags
    system "./test"
  end
end
