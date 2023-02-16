class Mfoc < Formula
  desc "Implementation of 'offline nested' attack by Nethemba"
  homepage "https://github.com/nfc-tools/mfoc"
  url "https://github.com/nfc-tools/mfoc/archive/refs/tags/mfoc-0.10.7.tar.gz"
  sha256 "2dfd8ffa4a8b357807680d190a91c8cf3db54b4211a781edc1108af401dbaad7"
  license "GPL-2.0-only"
  revision 2
  head "https://github.com/nfc-tools/mfoc.git"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "198199b28fba78263ae5f47178b4fc1334034e6f9501a2e75725676b7d83ebb3"
    sha256 cellar: :any,                 arm64_monterey: "7c6a3bbe0b0887b422c6cb36c63fcc91080ad0455b00fe8d8c64e41db1c8b99c"
    sha256 cellar: :any,                 arm64_big_sur:  "3cc80a2304a700b31494408fe1ee6472f51c8e5b10923b3ebd4eb912e0de6856"
    sha256 cellar: :any,                 ventura:        "b5721da4924a43bc6c048a2b56de3fa1ddd734a9c56330f283180f152fde9e63"
    sha256 cellar: :any,                 monterey:       "11d48f0e03ae7c99ffae54be35bd998c94d664855b8217e3eec582823b4200f6"
    sha256 cellar: :any,                 big_sur:        "c125e9e825aab3635d44128051d40413637725c6eded47b89c3727f3b8c04621"
    sha256 cellar: :any,                 catalina:       "14c431c29b0b0e746d1533606ab13097a84b853c13d4399672027cf9256dad32"
    sha256 cellar: :any,                 mojave:         "ff9f6c43ef70b8ae6fee40c43cf5f0acd6f72acd5507874e75d82703aeed5fc3"
    sha256 cellar: :any,                 high_sierra:    "83a0236f5971e007e67e620730d458f8dcdcb7ff7770cc97c07407a771dbf69a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42a1e94b179175e30631ae1d85e59a8d106def94007da48b2c98ccf09e16b13f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libnfc"
  depends_on "libusb"

  def install
    system "autoreconf", "-is"
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "No NFC device found", shell_output("#{bin}/mfoc -O /dev/null", 1)
  end
end
