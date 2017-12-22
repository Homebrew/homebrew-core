class PcscLite < Formula
  desc "Middleware to access a smart card using SCard API"
  homepage "https://pcsclite.alioth.debian.org"
  url "https://alioth.debian.org/frs/download.php/file/4235/pcsc-lite-1.8.23.tar.bz2"
  sha256 "5a27262586eff39cfd5c19aadc8891dd71c0818d3d629539bd631b958be689c9"

  bottle do
    sha256 "294e8028aa33a7727525438c3893390de5a3c89aa7b4da75f5e63d1bb7a8a942" => :high_sierra
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
                          "--disable-libsystemd"
    system "make", "install"
  end

  test do
    system sbin/"pcscd", "--version"
  end
end
