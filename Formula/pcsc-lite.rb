class PcscLite < Formula
  desc "Middleware to access a smart card using SCard API"
  homepage "https://pcsclite.alioth.debian.org"
  url "https://alioth.debian.org/frs/download.php/file/4216/pcsc-lite-1.8.21.tar.bz2"
  sha256 "fe3365eb7d4ce0fe891e2b6d6248351c287435ca502103f1f1431b1710e513ad"

  bottle do
    sha256 "29a9723a96c8bd3c3710463f84cac31595637dfac9b59689ed57c3d275262908" => :sierra
    sha256 "26c1637f5205fb382bbbee1fc7b4cfb3e38271909fc0952017b87263660b1c91" => :el_capitan
    sha256 "30a3b6f12235d167fa7a7f5ece357a87445857698180d4b650a6f01b2199826a" => :yosemite
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
