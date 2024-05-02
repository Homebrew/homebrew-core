class Bluez < Formula
  desc "Bluetooth protocol stack for Linux"
  homepage "https://github.com/bluez/bluez"
  url "https://mirrors.edge.kernel.org/pub/linux/bluetooth/bluez-5.75.tar.xz"
  sha256 "988cb3c4551f6e3a667708a578f5ca9f93fc896508f98f08709be4f8ab033c2f"
  license "GPL-2.0-or-later"

  bottle do
    sha256 x86_64_linux: "ca2128a9e8830ab62b2b23a00a98857e2fecd4fc3f1014a44c1a33f119e2824c"
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
