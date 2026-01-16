class Libnfc < Formula
  desc "Low level NFC SDK and Programmers API"
  homepage "https://github.com/nfc-tools/libnfc"
  url "https://github.com/nfc-tools/libnfc/releases/download/libnfc-1.8.0/libnfc-1.8.0.tar.bz2"
  sha256 "6d9ad31c86408711f0a60f05b1933101c7497683c2e0d8917d1611a3feba3dd5"
  license "LGPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "433f60511a9266fb1693203fbf2c91222603118e9057fb8cac76eb897edffa61"
    sha256 arm64_sequoia:  "2b82cd576da101ec339171c4a8ded0fee90ab4cf072513c8cd0a1b99721c72f9"
    sha256 arm64_sonoma:   "3e1ce25513819c59c110f28cfdb8cf4ecf265800d741d272ad7450805ba647f5"
    sha256 arm64_ventura:  "28002ee7cadbe88fdd4a614804a813b4d46a17d4cb2a1fe7d24fe17eff04f933"
    sha256 arm64_monterey: "24d476cf0560256e53b5efb4f915ead0e5a5bf336da89395a3b8a5c0903f1caf"
    sha256 arm64_big_sur:  "6e97d8892b2129437513be8a21fccf7e3c6a23b14dd28e3d43aea1fce9b97ed7"
    sha256 sonoma:         "f47d6668b25a9c0acb0eea36a27c0e340ebdb15859de78193e50e0adc38005e0"
    sha256 ventura:        "00719d9f9c924aa855561160b5a79bae50180c6245d7a98c520ab2993fb8d305"
    sha256 monterey:       "a42411e1b19e52e85c138f4566613bc87570851403d148315d384d953d2a82b5"
    sha256 big_sur:        "566a81b623abfb5d68480274b59b13c44fc098cd1d8cbf59dc112295a58a363c"
    sha256 catalina:       "6659f67e40774cdb8e95548c03542bbc123ccabc0f4a6160504c03e43fa43c26"
    sha256 arm64_linux:    "65c10bb5ef9996f755126c6642fd8933c9fa2fbff028d1700dc75b2cd0458b47"
    sha256 x86_64_linux:   "db84cf74f8217a9cb32aa5c804cf20c9b74464ce21ea2a87805b0c8de5abdfe6"
  end

  head do
    url "https://github.com/nfc-tools/libnfc.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "libusb-compat"

  uses_from_macos "pcsc-lite"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--enable-serial-autoprobe",
                          "--with-drivers=all",
                          *std_configure_args
    system "make", "install"
    (prefix/"etc/nfc/libnfc.conf").write "allow_intrusive_scan=yes"
  end

  test do
    system bin/"nfc-list"
  end
end
