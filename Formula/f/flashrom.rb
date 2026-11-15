class Flashrom < Formula
  desc "Identify, read, write, verify, and erase flash chips"
  homepage "https://flashrom.org/"
  url "https://download.flashrom.org/releases/flashrom-v1.8.0.tar.xz"
  sha256 "654c9c61745c250cd3b5ccd0e56fc43ee76980f92a5e078420420639d66975a2"
  license "GPL-2.0-or-later"
  head "https://review.coreboot.org/flashrom.git", branch: "main"

  livecheck do
    url "https://download.flashrom.org/releases/"
    regex(/href=.*?flashrom[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "0f3053314f9403e0c2717a333f62f5431ddc888a425ec0dab9636f0e63feccd5"
    sha256 cellar: :any, arm64_tahoe:       "de92cfb1a0a58ded94110328febd98a9452de05d1f9e81c4027342103a1e24ca"
    sha256 cellar: :any, arm64_sequoia:     "8738abe3c4deebf1835d30044570b4a8b1d93fff25d3dda72f7f7219f0dd3c82"
    sha256 cellar: :any, arm64_linux:       "e0559039e6668b96c5f799f1c0696977f5dd71b785cb0d913ba95183bb5bc21f"
    sha256 cellar: :any, x86_64_linux:      "498c5f46e5c462cb4b50ccc2abbbf1d28580af0642133c4a370b85b6ab81dde0"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "libftdi"
  depends_on "libjaylink"
  depends_on "libusb"
  depends_on "openssl@4"

  resource "DirectHW" do
    url "https://github.com/PureDarwin/DirectHW/archive/refs/tags/DirectHW-1.tar.gz"
    sha256 "14cc45a1a2c1a543717b1de0892c196534137db177413b9b85bedbe15cbe4563"
  end

  def install
    ENV["CONFIG_RAYER_SPI"] = "no"
    ENV["CONFIG_ENABLE_LIBPCI_PROGRAMMERS"] = "no"

    # install DirectHW for osx x86 builds
    if OS.mac? && Hardware::CPU.intel?
      (buildpath/"DirectHW").install resource("DirectHW")
      ENV.append "CFLAGS", "-I#{buildpath}"
    end

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system sbin/"flashrom", "--version"

    output = shell_output("#{sbin}/flashrom --erase --programmer dummy 2>&1", 1)
    assert_match "No EEPROM/flash device found", output
  end
end
