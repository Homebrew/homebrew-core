class Flashrom < Formula
  desc "Identify, read, write, verify, and erase flash chips"
  homepage "https://flashrom.org/"
  url "https://download.flashrom.org/releases/flashrom-v1.6.0.tar.xz"
  sha256 "8b9db3987df9b5fc81e70189d017905dd5f6be1e1410347f22687ab6d4c94423"
  license "GPL-2.0-or-later"
  head "https://review.coreboot.org/flashrom.git", branch: "main"

  livecheck do
    url "https://download.flashrom.org/releases/"
    regex(/href=.*?flashrom[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ba6fa0e79ba319eb07cbddf2b49ae6028abdf148a354e0d1bd4d94579cb35246"
    sha256 cellar: :any, arm64_sequoia: "a3bedd4508ffed55ff21196ab2ccabdd22b284d48110b06f5d47b96eaee389c8"
    sha256 cellar: :any, arm64_sonoma:  "5526490700374c47a8af1b4be7e4ed94f51caf920cf9ea3b797924078c40abbe"
    sha256 cellar: :any, arm64_ventura: "d4d991c436d1802da0e353d4eebfd682409b9a45c89a71ee82dde1c73bb04933"
    sha256 cellar: :any, sonoma:        "34252dd54bc96c0ce719d0b17a291c51503a66afd3b31637b86a4d385efe504a"
    sha256 cellar: :any, ventura:       "e67286ae8d5dcada59554842a06aca7ec77494baaa5aaa1f4efd323cc6ec8eb9"
    sha256               arm64_linux:   "7be69e32a990a59fa7c76ff7aa22412dc03ed834e0b16395632d167482a50a46"
    sha256               x86_64_linux:  "aa9029390983c5f366e65614c3f7ac99602d4ff2e4db0b301e53440687db8cc7"
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
