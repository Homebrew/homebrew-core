class Flashrom < Formula
  desc "Identify, read, write, verify, and erase flash chips"
  homepage "https://flashrom.org/"
  url "https://download.flashrom.org/releases/flashrom-v1.1.tar.bz2"
  sha256 "aeada9c70c22421217c669356180c0deddd0b60876e63d2224e3260b90c14e19"
  head "https://review.coreboot.org/flashrom.git"

  bottle do
    cellar :any
    sha256 "268fed961b0db79dd20c9d7d0618d80a2b8fb8b81d19b31911bac5b61b89f557" => :mojave
    sha256 "9b52a8eed203c15987554132d532210c22e97f9a0eab02d842830c7339b544b7" => :high_sierra
    sha256 "ae6bb14a2a03c1a44515702f01c06e49e2526e831f0fd7e7cee3761a9bdfb6cd" => :sierra
    sha256 "7a41ea01cb4dfa262082f96f8a20eeccb45117aee72f806643a9783d92b247ef" => :el_capitan
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
