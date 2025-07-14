class Flashrom < Formula
  desc "Identify, read, write, verify, and erase flash chips"
  homepage "https://flashrom.org/"
  url "https://download.flashrom.org/releases/flashrom-v1.5.1.tar.xz"
  sha256 "1f934b076ed49eace203655ec249fc7861a6b8e87fe4aef732e47b6e485b6293"
  license "GPL-2.0-or-later"
  head "https://review.coreboot.org/flashrom.git", branch: "master"

  livecheck do
    url "https://download.flashrom.org/releases/"
    regex(/href=.*?flashrom[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "ccb844bba9ff0f004d66daddc0b834fe4a91eace389ae3486cc99854795ce807"
    sha256 cellar: :any, arm64_sonoma:  "2cada41d9ec587f23a4b6a8cdd4ff21a3c0b176c4da270c01b38a3cf4073a94c"
    sha256 cellar: :any, arm64_ventura: "d3aa6a371dccd77654c46ad73ba10dc4bfabedebb5a920eb9fde56fd21d1b96f"
    sha256 cellar: :any, sonoma:        "6dc12de3566c4f6078a22b979ce76e18100320bb004a9f463fffbe65ef72840b"
    sha256 cellar: :any, ventura:       "f853dbc8d2957263f3a6c0875a51c8f5760deb2fede2c1f02edce9b6946ad04b"
    sha256               arm64_linux:   "99930741fa83500c75daa0a4f5578a5365e3063e0151740a304c251376b9b6d3"
    sha256               x86_64_linux:  "e7ca720f79b5b454b2ee3c4268352042d6ee6036b23f004cba7b3333565f1e14"
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
