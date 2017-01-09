class PcscLite < Formula
  desc "Middleware to access a smart card using SCard API"
  homepage "https://pcsclite.alioth.debian.org"
  url "https://alioth.debian.org/frs/download.php/file/4203/pcsc-lite-1.8.20.tar.bz2"
  sha256 "ec7d0114016c788c1c09859c84860f6cec6c4595436d23245105154b9c046bb2"

  bottle do
    sha256 "c1d5af50c8b6ff831f3b20deb79d597e2c73f7af268760c845ddb23a8a932155" => :sierra
    sha256 "86a89000db018b25e696b73c18fd9986f8419fff86297f2ab4d462d168e28ae2" => :el_capitan
    sha256 "83faab4d9869a01bec70f89b4d0c93842b6320741d3ea08a96cf414bdb4bcaee" => :yosemite
  end

  keg_only :provided_by_osx,
    "pcsc-lite interferes with detection of macOS's PCSC.framework."

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-systemdsystemunitdir=no"
    system "make", "install"
  end

  test do
    system sbin/"pcscd", "--version"
  end
end
