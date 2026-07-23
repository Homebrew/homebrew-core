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
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "7f4b534c1651528d2f9d533d1d6086099c275f01ab2ed97d1dca416815ec4ac4"
    sha256 cellar: :any, arm64_sequoia: "3c4d73c0956dff122759bf402e944c58f68863f3994a1653041287ed58ba6b3f"
    sha256 cellar: :any, arm64_sonoma:  "6454b4ddab1122eaa09058f771eff661c4c1ad8c8be5489843117f867d329fb3"
    sha256 cellar: :any, sonoma:        "9ad26e249cfab29b3c643cf7f97cb751beaa552f19ee03e544688ae2e99b8382"
    sha256               arm64_linux:   "248fab896eaeb96a8ee1c619685d574fa2f3fed37c1e6cc7ba0a908fe874a624"
    sha256               x86_64_linux:  "8ae4f697a10c6ef1b0da1383cad1e90e338536bc4af9319e99a0611605f72e37"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "libftdi"
  depends_on "libjaylink"
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
