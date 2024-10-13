class Bluez < Formula
  desc "Bluetooth protocol stack for Linux"
  homepage "https://github.com/bluez/bluez"
  url "https://mirrors.edge.kernel.org/pub/linux/bluetooth/bluez-5.78.tar.xz"
  sha256 "830fed1915c5d375b8de0f5e6f45fcdea0dcc5ff5ffb3d31db6ed0f00d73c5e3"
  license "GPL-2.0-or-later"

  bottle do
    sha256 x86_64_linux: "0276e6308da5fdf6609c062ed84f3af6e6155fece84d9c36e40ecb810968a591"
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
