class Flashrom < Formula
  desc "Identify, read, write, verify, and erase flash chips"
  homepage "https://flashrom.org/"
  license "GPL-2.0-or-later"
  head "https://review.coreboot.org/flashrom.git", branch: "master"

  stable do
    url "https://download.flashrom.org/releases/flashrom-v1.2.1.tar.bz2"
    sha256 "89a7ff5beb08c89b8795bbd253a51b9453547a864c31793302296b56bbc56d65"

    # Add https://github.com/flashrom/flashrom/pull/212, to allow flashrom to build on Apple Silicon
    patch do
      url "https://github.com/areese/flashrom/commit/0c7b279d78f95083b686f6b1d4ce0f7b91bf0fd0.patch?full_index=1"
      sha256 "9e1f54f7ae4e67b880df069b419835131f72d166b3893870746fff456b0b7225"
    end
  end

  livecheck do
    url "https://download.flashrom.org/releases/"
    regex(/href=.*?flashrom[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e333d7b600ff538511491787f251b2f7ccc5adb83d3cb6d2d8e851cb0b7f383c"
    sha256 cellar: :any,                 arm64_monterey: "146d7682e5d7e4fa3cf903d9bce8e1b644a114e76399fe84e3be506cbabdc3ca"
    sha256 cellar: :any,                 arm64_big_sur:  "01c14e3cdb46c9a2fe4727f07db401ebceb33ff7d71164c11f6937b073aafc36"
    sha256 cellar: :any,                 ventura:        "e9a865790102fb834ff6cd092e9e27ac706c6e8dee9f97aa2490a20324c29836"
    sha256 cellar: :any,                 monterey:       "66d6161255682536219857be846944b006f675b1e068514b77380af8e9f5d985"
    sha256 cellar: :any,                 big_sur:        "613523b5edc4a0c6c575bdfd41346e7abec90318713d53a013fd0dc48912d5a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04d75c009bc6a07b25080087cb9ca12df91bcf67db422e607fe5e78c0a641ecc"
  end

  depends_on "pkg-config" => :build
  depends_on "libftdi"
  depends_on "libusb"

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
