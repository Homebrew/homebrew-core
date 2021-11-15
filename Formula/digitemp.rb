class Digitemp < Formula
  desc "Read temperature sensors in a 1-Wire net"
  homepage "https://www.digitemp.com/"
  url "https://github.com/bcl/digitemp/archive/v3.7.2.tar.gz"
  sha256 "683df4ab5cc53a45fe4f860c698f148d34bcca91b3e0568a342f32d64d12ba24"
  license "GPL-2.0"
  head "https://github.com/bcl/digitemp.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8de47e480d9a46e00ca897acad3787f7c6897aefe28e63f3008aa7c736112e17"
    sha256 cellar: :any,                 arm64_big_sur:  "d63a759441dd683b447bc9db45786b1bce2f662d67a340d81048b8a25daa021f"
    sha256 cellar: :any,                 monterey:       "b184352eb21cbca65269b7b0ae3da2213791b53530f515c91a0edc44a37d0534"
    sha256 cellar: :any,                 big_sur:        "dfcce60792d55b3d715c7cadb3179193ce943edb291913423c34456b53a1ac37"
    sha256 cellar: :any,                 catalina:       "6d79bfded73a02e6c84d90c5437226567389212bf07d0b15b355465db645c6ec"
    sha256 cellar: :any,                 mojave:         "54fbf374d90a378d49b86174f4c00e0a56a1cee599d040a740469d7ad7b3a991"
    sha256 cellar: :any,                 high_sierra:    "a91be4056f24f4bef0c19c8a3693d48e0f7d391494e7db1be416ab1eb833daa2"
    sha256 cellar: :any,                 sierra:         "dab9de93acb1edb05e3607075b36ce233e567dd9a1918aacf3b19f3826aa30ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f307cb2ce339c2b19089b46fc564e4492126b75abea1c79ca31fe6debfa5341"
  end

  depends_on "libusb-compat"

  def install
    mkdir_p "build-serial/src"
    mkdir_p "build-serial/userial/ds9097"
    mkdir_p "build-serial/userial/ds9097u"
    mkdir_p "build-usb/src"
    mkdir_p "build-usb/userial/ds2490"
    system "make", "-C", "build-serial", "-f", "../Makefile", "SRCDIR=..", "ds9097", "ds9097u"
    system "make", "-C", "build-usb", "-f", "../Makefile", "SRCDIR=..", "ds2490"
    bin.install "build-serial/digitemp_DS9097"
    bin.install "build-serial/digitemp_DS9097U"
    bin.install "build-usb/digitemp_DS2490"
    man1.install "digitemp.1"
    man1.install_symlink "digitemp.1" => "digitemp_DS9097.1"
    man1.install_symlink "digitemp.1" => "digitemp_DS9097U.1"
    man1.install_symlink "digitemp.1" => "digitemp_DS2490.1"
  end

  # digitemp has no self-tests and does nothing without a 1-wire device,
  # so at least check the individual binaries compiled to what we expect.
  test do
    assert_match "Compiled for DS2490", shell_output("#{bin}/digitemp_DS2490 2>&1", 255)
    assert_match "Compiled for DS9097", shell_output("#{bin}/digitemp_DS9097 2>&1", 255)
    assert_match "Compiled for DS9097U", shell_output("#{bin}/digitemp_DS9097U 2>&1", 255)
  end
end
