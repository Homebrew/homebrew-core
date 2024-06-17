class Bluez < Formula
  desc "Bluetooth protocol stack for Linux"
  homepage "https://github.com/bluez/bluez"
  url "https://mirrors.edge.kernel.org/pub/linux/bluetooth/bluez-5.76.tar.xz"
  sha256 "55e2c645909ad82d833c42ce85ec20434e0ef0070941b1eab73facdd240bbd63"
  license "GPL-2.0-or-later"

  bottle do
    sha256 x86_64_linux: "e9f405abda461494a98d39e01e94765044f98ff4dc78391be9fc92836fa9b6b1"
  end

  depends_on "pkg-config" => :build
  depends_on "dbus"
  depends_on "glib"
  depends_on "libical"
  depends_on :linux
  depends_on "readline"
  depends_on "systemd" # for libudev

  def install
    system "./configure", "--disable-testing", "--disable-manpages", "--enable-library", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bluetoothctl --version")

    assert_match "Failed to open HCI user channel", shell_output("#{bin}/bluemoon 2>&1", 1)

    output = shell_output("#{bin}/btmon 2>&1", 1)
    assert_match "Failed to open channel: Address family not supported by protocol", output
  end
end
