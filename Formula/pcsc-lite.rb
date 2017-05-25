class PcscLite < Formula
  desc "Middleware to access a smart card using SCard API"
  homepage "https://pcsclite.alioth.debian.org"
  url "https://alioth.debian.org/frs/download.php/file/4216/pcsc-lite-1.8.21.tar.bz2"
  sha256 "fe3365eb7d4ce0fe891e2b6d6248351c287435ca502103f1f1431b1710e513ad"

  bottle do
    sha256 "0cf13c92847d79113c18046de5bba33e154c89b3d5ddb2eb8a1510a740e3a2ab" => :sierra
    sha256 "4dae204aa9af497a06a6cbd102f892ba6d41e3c8da2480ea1b057aa9fb7d1aad" => :el_capitan
    sha256 "8369d8cf480a4c86005c5522fdeb30dc40c09331e674c5eaa03b42823cd6f2e7" => :yosemite
  end

  keg_only :provided_by_osx,
    "pcsc-lite interferes with detection of macOS's PCSC.framework"

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
