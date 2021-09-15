class Libhid < Formula
  desc "Library to access and interact with USB HID devices"
  homepage "https://directory.fsf.org/wiki/Libhid"
  url "https://pkg.freebsd.org/ports-distfiles/libhid-0.2.16.tar.gz"
  sha256 "f6809ab3b9c907cbb05ceba9ee6ca23a705f85fd71588518e14b3a7d9f2550e5"
  license "GPL-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?libhid[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "01170cf4863c640d89c02c1c8d10759aa9ab7b16a0ab88bccdefdf10c5174620"
    sha256 cellar: :any,                 big_sur:       "33539f7a9be0592c28fc6b4c7d1866603cf115441fcf72db5ca67f99149b63c4"
    sha256 cellar: :any,                 catalina:      "049d5c106ab738e55af18878f19cc0510d78bbda54f0c5626e3ccb725e415c68"
    sha256 cellar: :any,                 mojave:        "7457dc1791e661356e54059fb7b49f9629f2814694057bb38c6ad6698b3c4556"
    sha256 cellar: :any,                 high_sierra:   "b2949cef974f368856304506aecea44d3daca81b2d8c798bc141ef376723eded"
    sha256 cellar: :any,                 sierra:        "b92f274a981788b3092927223099f4f3220877417c766ec8e8bd63171e9a9849"
    sha256 cellar: :any,                 el_capitan:    "a22388fc2ac89d99ed04449c590b035308a81c8f1a2e80ee68ca64a7e10ced7e"
    sha256 cellar: :any,                 yosemite:      "4920ff4278cbc288fc8c84ef9b3137d99010ba047d6f072b9a6eccf07588721a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb334329832a5847225997b9b7bb0f54a0e26c69636f34cd3b1af77475eef922"
  end

  depends_on "libusb"
  depends_on "libusb-compat"

  # Fix compilation error on 10.9
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/libhid/0.2.16.patch"
    sha256 "443a3218902054b7fc7a9f91fd1601d50e2cc7bdca3f16e75419b3b60f2dab81"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-swig"

    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <hid.h>
      int main(void) {
        hid_init();
        return hid_cleanup();
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lhid", "-o", "test"
    system "./test"
  end
end
