class Mfoc < Formula
  desc "Implementation of 'offline nested' attack by Nethemba"
  homepage "https://github.com/nfc-tools/mfoc"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/mfoc/mfoc-0.10.7.tar.bz2"
  sha256 "93d8ac4cb0aa6ed94855ca9732a2ffd898a9095c087f12f9402205443c2eb98c"
  license "GPL-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7c6a3bbe0b0887b422c6cb36c63fcc91080ad0455b00fe8d8c64e41db1c8b99c"
    sha256 cellar: :any,                 arm64_big_sur:  "3cc80a2304a700b31494408fe1ee6472f51c8e5b10923b3ebd4eb912e0de6856"
    sha256 cellar: :any,                 monterey:       "11d48f0e03ae7c99ffae54be35bd998c94d664855b8217e3eec582823b4200f6"
    sha256 cellar: :any,                 big_sur:        "c125e9e825aab3635d44128051d40413637725c6eded47b89c3727f3b8c04621"
    sha256 cellar: :any,                 catalina:       "14c431c29b0b0e746d1533606ab13097a84b853c13d4399672027cf9256dad32"
    sha256 cellar: :any,                 mojave:         "ff9f6c43ef70b8ae6fee40c43cf5f0acd6f72acd5507874e75d82703aeed5fc3"
    sha256 cellar: :any,                 high_sierra:    "83a0236f5971e007e67e620730d458f8dcdcb7ff7770cc97c07407a771dbf69a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42a1e94b179175e30631ae1d85e59a8d106def94007da48b2c98ccf09e16b13f"
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
