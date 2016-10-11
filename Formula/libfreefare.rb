class Libfreefare < Formula
  desc "API for MIFARE card manipulations"
  homepage "https://github.com/nfc-tools/libfreefare"
  url "https://github.com/nfc-tools/libfreefare/releases/download/libfreefare-0.4.0/libfreefare-0.4.0.tar.bz2"
  sha256 "bfa31d14a99a1247f5ed49195d6373de512e3eb75bf1627658b40cf7f876bc64"
  revision 1

  bottle do
    cellar :any
    sha256 "03d3fffd9c4cf59b2a5a735e2b32262a7bbe1dde56e7ebf6d0e9f71eff8def87" => :sierra
    sha256 "3314a682b1c0443f3e924bdc4a3294de0d3d979860224f72b74531701915f914" => :el_capitan
    sha256 "673490a072b9154050596a7f189c9f49f4c4b314fecfc2acf8c851716fbd6de7" => :yosemite
    sha256 "d4e5f965c145948da6a9dd8edb7e6475b3fa0504ac06a0885ce391f94a3edffa" => :mavericks
    sha256 "83eb9ce57c62b8c08c912452642ea75cfb5377ded85073cd3c7d709d38ccc5f5" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libnfc"
  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
