class Libnfc < Formula
  desc "Low level NFC SDK and Programmers API"
  homepage "https://github.com/nfc-tools/libnfc"
  url "https://github.com/nfc-tools/libnfc/releases/download/libnfc-1.8.0/libnfc-1.8.0.tar.bz2"
  sha256 "6d9ad31c86408711f0a60f05b1933101c7497683c2e0d8917d1611a3feba3dd5"
  license "LGPL-3.0"

  bottle do
    sha256 "6659f67e40774cdb8e95548c03542bbc123ccabc0f4a6160504c03e43fa43c26" => :catalina
    sha256 "9bc90c84f89408a8960289a668af7ad9b7b17d34a02996b83ec960c5cbefafeb" => :mojave
    sha256 "8e6abd4d61ef9aff76ef25b092806b95614c07a9e46a0e13ca6e915271454a92" => :high_sierra
  end

  head do
    url "https://github.com/nfc-tools/libnfc.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libusb-compat"

  def install
    system "autoreconf", "-vfi" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--enable-serial-autoprobe",
                          "--with-drivers=all"
    system "make", "install"
    (prefix/"etc/nfc/libnfc.conf").write "allow_intrusive_scan=yes"
  end

  test do
    system "#{bin}/nfc-list"
  end
end
