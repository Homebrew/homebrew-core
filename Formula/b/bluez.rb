class Bluez < Formula
  desc "Bluetooth protocol stack for Linux"
  homepage "https://www.bluez.org"
  url "https://mirrors.edge.kernel.org/pub/linux/bluetooth/bluez-5.85.tar.xz"
  sha256 "ad028e49254bc4551a13f08fe7904c63d02ba650d77be8ae15bb3b0a0ad94a6f"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/linux/bluetooth/"
    regex(/href=.*?bluez[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_linux:  "3cbc716a9ba391cc0b6fae51ca287c3d271bcf3678a5565b3275c52db0c1cd09"
    sha256 x86_64_linux: "167d70648e27acdec6714f30f7f2cff380ffd2edf150c15a4c8a7d2a14b96345"
  end

  head do
    url "https://git.kernel.org/pub/scm/bluetooth/bluez.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "dbus"
  depends_on "glib"
  depends_on "libical"
  depends_on :linux
  depends_on "readline"
  depends_on "systemd" # for libudev

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-testing", "--disable-manpages", "--enable-library", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bluetoothctl --version") unless head?

    assert_match "Failed to open HCI user channel", shell_output("#{bin}/bluemoon 2>&1", 1)

    output = shell_output("#{bin}/btmon 2>&1", 1)
    assert_match "Failed to open channel: Address family not supported by protocol", output
  end
end
