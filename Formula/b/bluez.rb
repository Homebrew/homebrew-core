class Bluez < Formula
  desc "Bluetooth protocol stack for Linux"
  homepage "https://bluez.github.io/"
  url "https://mirrors.edge.kernel.org/pub/linux/bluetooth/bluez-5.88.tar.xz"
  sha256 "6952c39eb5f8b0ee712cc50ab3bcff03be17c410dd97ca640f4849d9a1653ba3"
  license "GPL-2.0-or-later"
  compatibility_version 1

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/linux/bluetooth/"
    regex(/href=.*?bluez[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_linux:  "54fdbacf7930a20975c41ce119a969071801d5f33202d04ade461e708c319242"
    sha256 x86_64_linux: "22858468eb405d2383160ffa7ac54fe02cb92542ebd6ac1ba532235e2436e709"
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

  allow_network_access! :test

  def install
    # libical 4 split vCard helpers into libicalvcal; obexd needs it linked.
    ENV.append "LIBS", "-licalvcal"

    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    # D-Bus and systemd unit dirs default to the read-only dep kegs; use our own prefix
    system "./configure", "--disable-testing", "--disable-manpages", "--enable-library",
           "--with-dbusconfdir=#{share}",
           "--with-dbussystembusdir=#{share}/dbus-1/system-services",
           "--with-dbussessionbusdir=#{share}/dbus-1/services",
           "--with-systemdsystemunitdir=#{lib}/systemd/system",
           "--with-systemduserunitdir=#{lib}/systemd/user",
           *std_configure_args
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
