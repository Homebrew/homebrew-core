class PcscLite < Formula
  desc "Middleware to access a smart card using SCard API"
  homepage "https://pcsclite.apdu.fr/"
  url "https://pcsclite.apdu.fr/files/pcsc-lite-1.8.26.tar.bz2"
  sha256 "3eb7be7d6ef618c0a444316cf5c1f2f9d7227aedba7a192f389fe3e7c0dfbbd9"

  bottle do
    cellar :any
    sha256 "d4fdefb11d6fcfb20ffb8aac8be408d4c1041fd981caabc42a6d482fd980ca62" => :catalina
    sha256 "29ebb59b42af0959efe85ca374d03cd51984b9966c3be2ed51c8ae30098e0ea2" => :mojave
    sha256 "832957657fec785b6d157a6a670da607675bdef8655d82c3a16fc39e305e5e57" => :high_sierra
    sha256 "92fb7438f0467c2f749218cb8b23fa1bf66425fb8f49b20888530fb97094598f" => :sierra
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
