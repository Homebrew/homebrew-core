class Hidapi < Formula
  desc "Library for communicating with USB and Bluetooth HID devices"
  homepage "https://github.com/libusb/hidapi"
  url "https://github.com/libusb/hidapi/archive/hidapi-0.9.0.tar.gz"
  sha256 "630ee1834bdd5c5761ab079fd04f463a89585df8fcae51a7bfe4229b1e02a652"
  head "https://github.com/libusb/hidapi.git"

  bottle do
    cellar :any
    sha256 "8e4c1959c227e51e8bc8e45532838dff3fd5c58aff90a03eb1e19d9cd51f7160" => :mojave
    sha256 "0b972366a1dc78445d448b40892ef7885fb682eb2042e41723274d2e50388732" => :high_sierra
    sha256 "befada3ffe32de1d7363d0a958aec534b248d8cd45111c4f30a6f46bb0ac401b" => :sierra
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
