class Libnfc < Formula
  desc "Low level NFC SDK and Programmers API"
  homepage "https://github.com/nfc-tools/libnfc"
  url "https://github.com/nfc-tools/libnfc/releases/download/libnfc-1.8.0/libnfc-1.8.0.tar.bz2"
  sha256 "6d9ad31c86408711f0a60f05b1933101c7497683c2e0d8917d1611a3feba3dd5"
  license "LGPL-3.0"

  bottle do
    sha256 arm64_monterey: "24d476cf0560256e53b5efb4f915ead0e5a5bf336da89395a3b8a5c0903f1caf"
    sha256 arm64_big_sur:  "6e97d8892b2129437513be8a21fccf7e3c6a23b14dd28e3d43aea1fce9b97ed7"
    sha256 monterey:       "a42411e1b19e52e85c138f4566613bc87570851403d148315d384d953d2a82b5"
    sha256 big_sur:        "566a81b623abfb5d68480274b59b13c44fc098cd1d8cbf59dc112295a58a363c"
    sha256 catalina:       "6659f67e40774cdb8e95548c03542bbc123ccabc0f4a6160504c03e43fa43c26"
    sha256 mojave:         "9bc90c84f89408a8960289a668af7ad9b7b17d34a02996b83ec960c5cbefafeb"
    sha256 high_sierra:    "8e6abd4d61ef9aff76ef25b092806b95614c07a9e46a0e13ca6e915271454a92"
    sha256 x86_64_linux:   "db84cf74f8217a9cb32aa5c804cf20c9b74464ce21ea2a87805b0c8de5abdfe6"
  end

  head do
    url "https://github.com/nfc-tools/libnfc.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libusb-compat"

  uses_from_macos "pcsc-lite"

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
