class Bluez < Formula
  desc "Bluetooth protocol stack for Linux"
  homepage "https://github.com/bluez/bluez"
  url "https://mirrors.edge.kernel.org/pub/linux/bluetooth/bluez-5.73.tar.xz"
  sha256 "257e9075ce05c70d48c5defd254e78c418416f7584b45f9dddc884ff88e3fc53"
  license "GPL-2.0-or-later"

  bottle do
    sha256 x86_64_linux: "0ccb55d4cba7cdfaf45f3936fd4f0eba7135063339ab2b2648da296646f7324e"
  end

  depends_on "pkg-config" => :build
  depends_on "dbus"
  depends_on "glib"
  depends_on "libical"
  depends_on :linux
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
