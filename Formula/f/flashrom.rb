class Flashrom < Formula
  desc "Identify, read, write, verify, and erase flash chips"
  homepage "https://flashrom.org/"
  url "https://download.flashrom.org/releases/flashrom-v1.7.0.tar.xz"
  sha256 "4328ace9833f7efe7c334bdd73482cde8286819826cc00149e83fba96bf3ab4f"
  license "GPL-2.0-or-later"
  head "https://review.coreboot.org/flashrom.git", branch: "main"

  livecheck do
    url "https://download.flashrom.org/releases/"
    regex(/href=.*?flashrom[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bddf59497d339e94335a78dcd020f39c2abeb6ab6743d2879425af065cc09cf1"
    sha256 cellar: :any, arm64_sequoia: "7f44705e5537d6294a8b740c64f5f4ca9ea348d67ebb39e1da7f9bb1ac311568"
    sha256 cellar: :any, arm64_sonoma:  "a675503867c985d6ff3599597a692283c47009ba672d1b0267e8ea58c7101c84"
    sha256 cellar: :any, sonoma:        "7fff618fcbcc53469b5ccb96826f2db688098ef222a0afc55ecf2970dc5f6e8f"
    sha256               arm64_linux:   "fa19b35b685c9ce8e2ba999ee52869440da81e6abe9271c843503548e9cfc85d"
    sha256               x86_64_linux:  "8746313816786192056a06b6f94cb8aa0111984edca71343560e72af081669c0"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "libftdi"
  depends_on "libusb"
  depends_on "openssl@3"

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
