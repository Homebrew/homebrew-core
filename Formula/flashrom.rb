class Flashrom < Formula
  desc "Identify, read, write, verify, and erase flash chips"
  homepage "https://flashrom.org/"
  url "https://download.flashrom.org/releases/flashrom-v1.2.tar.bz2"
  sha256 "e1f8d95881f5a4365dfe58776ce821dfcee0f138f75d0f44f8a3cd032d9ea42b"
  license "GPL-2.0"
  head "https://review.coreboot.org/flashrom.git"

  livecheck do
    url "https://download.flashrom.org/releases/"
    regex(/href=.*?flashrom[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "aa5c0856318732adf6a2bb4b980cef8a21829bd6a606beb357cae3ca71561217" => :big_sur
    sha256 "301d0aafe8b31a53e6ee77217ce2280d1e998ceb7c8bc1a54a85c88afa940a33" => :catalina
    sha256 "69131a69023cd0336b8c9c9f1a56cafb28509f1e8eb5ada0bd45ff48357df38c" => :mojave
    sha256 "08d74d59cb4a56347de27465cc289b6494199951e2d251fafc328b4dc2f3e1e3" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libftdi0"
  depends_on "libusb-compat"

  def install
    ENV["CONFIG_RAYER_SPI"] = "no"
    ENV["CONFIG_ENABLE_LIBPCI_PROGRAMMERS"] = "no"

    system "make", "DESTDIR=#{prefix}", "PREFIX=/", "install"
    mv sbin, bin
  end

  test do
    system bin/"flashrom", "--version"
  end
end
