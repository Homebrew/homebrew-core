class PcscLite < Formula
  desc "Middleware to access a smart card using SCard API"
  homepage "https://pcsclite.alioth.debian.org"
  url "https://alioth.debian.org/frs/download.php/file/4235/pcsc-lite-1.8.23.tar.bz2"
  sha256 "5a27262586eff39cfd5c19aadc8891dd71c0818d3d629539bd631b958be689c9"

  bottle do
    sha256 "0ed981ad7244d50d3084cef08991c5662658cd321d24784b2a6c2f8586f8f205" => :high_sierra
    sha256 "16167530e755c8c59a43b72433e9e1aba53b14f4f7364e85fc3159ecdc8ce75b" => :sierra
    sha256 "9a2816b3aaa1717d6c5d2c59495681915b62de67e496bb3edfecf1e5b6d537c0" => :el_capitan
  end

  keg_only :provided_by_macos,
    "pcsc-lite interferes with detection of macOS's PCSC.framework"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--disable-libsystemd"
    system "make", "install"
  end

  test do
    system sbin/"pcscd", "--version"
  end
end
