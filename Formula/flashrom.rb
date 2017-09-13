class Flashrom < Formula
  desc "Identify, read, write, verify, and erase flash chips"
  homepage "https://flashrom.org/"
  url "https://download.flashrom.org/releases/flashrom-0.9.9.tar.bz2"
  sha256 "cb3156b0f63eb192024b76c0814135930297aac41f80761a5d293de769783c45"
  head "https://code.coreboot.org/svn/flashrom/trunk", :using => :svn

  bottle do
    cellar :any
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
