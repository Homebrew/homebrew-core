class Mfoc < Formula
  desc "Implementation of 'offline nested' attack by Nethemba"
  homepage "https://github.com/nfc-tools/mfoc"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/mfoc/mfoc-0.10.7.tar.bz2"
  sha256 "93d8ac4cb0aa6ed94855ca9732a2ffd898a9095c087f12f9402205443c2eb98c"
  license "GPL-2.0"
  revision 1

  bottle do
    cellar :any
    sha256 "c125e9e825aab3635d44128051d40413637725c6eded47b89c3727f3b8c04621" => :big_sur
    sha256 "3cc80a2304a700b31494408fe1ee6472f51c8e5b10923b3ebd4eb912e0de6856" => :arm64_big_sur
    sha256 "14c431c29b0b0e746d1533606ab13097a84b853c13d4399672027cf9256dad32" => :catalina
    sha256 "ff9f6c43ef70b8ae6fee40c43cf5f0acd6f72acd5507874e75d82703aeed5fc3" => :mojave
    sha256 "83a0236f5971e007e67e620730d458f8dcdcb7ff7770cc97c07407a771dbf69a" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libnfc"
  depends_on "libusb"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"mfoc", "-h"
  end
end
