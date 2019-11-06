class Flashrom < Formula
  desc "Identify, read, write, verify, and erase flash chips"
  homepage "https://flashrom.org/"
  url "https://download.flashrom.org/releases/flashrom-v1.1.tar.bz2"
  sha256 "aeada9c70c22421217c669356180c0deddd0b60876e63d2224e3260b90c14e19"
  head "https://review.coreboot.org/flashrom.git"

  bottle do
    cellar :any
    sha256 "d480e3663325cb80aab14d5b99b65c89e392711c531fdbe420bb033b1d1c00c3" => :catalina
    sha256 "1878ea1416cf64c84393b0701473e571432cc709368c88ce72b20eb5e9185805" => :mojave
    sha256 "a08518e33d4bb2cf514441a654d0986ba19afd9e05cf7b7949aa09a5fb167d50" => :high_sierra
    sha256 "556848f98ccc1e0ff82a15dea1aef4f2a9376be54a0e7ae6149780aba8e8e2d3" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libftdi0"
  depends_on "libusb-compat"

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
