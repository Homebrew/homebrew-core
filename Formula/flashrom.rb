class Flashrom < Formula
  desc "Identify, read, write, verify, and erase flash chips"
  homepage "https://flashrom.org/"
  url "https://download.flashrom.org/releases/flashrom-1.0.tar.bz2"
  sha256 "3702fa215ba5fb5af8e54c852d239899cfa1389194c1e51cb2a170c4dc9dee64"
  head "https://review.coreboot.org/flashrom.git"

  bottle do
    cellar :any
    sha256 "8a4b99ba9d265654a48038ccf8833489cdfef64eec1ff5fff9c0b33b7da01197" => :high_sierra
    sha256 "a94e756a9ead25454461e5e96d7ba03e174b7fb98de10daf6e766874f97b19bd" => :sierra
    sha256 "1d5ff4b5b6b201f65007f322a92c93d8337cbdcc028d9b777eba2c3736a59361" => :el_capitan
    sha256 "8d8114627429244e48956866024f977c06dc5ca75b871a66edcd16bde456816e" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libusb-compat"
  depends_on "libftdi0"

  def install
    ENV["CONFIG_GFXNVIDIA"] = "0"
    ENV["CONFIG_NIC3COM"] = "0"
    ENV["CONFIG_NICREALTEK"] = "0"
    ENV["CONFIG_NICNATSEMI"] = "0"
    ENV["CONFIG_NICINTEL"] = "0"
    ENV["CONFIG_NICINTEL_SPI"] = "0"
    ENV["CONFIG_NICINTEL_EEPROM"] = "0"
    ENV["CONFIG_OGP_SPI"] = "0"
    ENV["CONFIG_SATAMV"] = "0"
    ENV["CONFIG_SATASII"] = "0"
    ENV["CONFIG_DRKAISER"] = "0"
    ENV["CONFIG_RAYER_SPI"] = "0"
    ENV["CONFIG_INTERNAL"] = "0"
    ENV["CONFIG_IT8212"] = "0"
    ENV["CONFIG_ATAHPT"] = "0"
    ENV["CONFIG_ATAVIA"] = "0"

    system "make", "DESTDIR=#{prefix}", "PREFIX=/", "install"
    mv sbin, bin
  end

  test do
    system "#{bin}/flashrom" " --version"
  end
end
