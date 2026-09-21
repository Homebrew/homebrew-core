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
    sha256 cellar: :any, arm64_golden_gate: "05fc622d67c4e9e8217ec1b6678bd6c031a1919678909bf96d7347e2a8321171"
    sha256 cellar: :any, arm64_tahoe:       "abef39cb494d1475064b425daa8a0d12562bab5e608860178ddceb74a3d4ae02"
    sha256 cellar: :any, arm64_sequoia:     "c9c225aa76b4dbdcfa75a7f8b2ab3f2bfb1db0bcf8980e837ea332dfa6e8dd40"
    sha256 cellar: :any, arm64_sonoma:      "0e5d1e2587bcfbff9e208486f066f95fad7bc8e3768bbe8f4cedbba35c84b6f8"
    sha256 cellar: :any, arm64_linux:       "62429c2654e7a723b1eba6f402f24a6862cb93e7e2e32e9f5453a33468942e26"
    sha256 cellar: :any, x86_64_linux:      "d94065e9ad3a5c19cc2a5ae33f03eaef78694c1c3b179e2ab064f58b866ca4f0"
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
