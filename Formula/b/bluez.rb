class Bluez < Formula
  desc "Bluetooth protocol stack for Linux"
  homepage "https://www.bluez.org"
  url "https://mirrors.edge.kernel.org/pub/linux/bluetooth/bluez-5.87.tar.xz"
  sha256 "26bdcf2cebd7310c6f598850606b037ef0c515fe6608ebc54d22c50c4c32b35f"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/linux/bluetooth/"
    regex(/href=.*?bluez[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_linux:  "4ed1db7a33290d4a83a1fdf7a11b4f6a5ce323fe47f0e6ea35e0a3e052814bac"
    sha256 x86_64_linux: "75b870b992cea33442f71fa849f35597488841b582753f4f8ea8b95987af698c"
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
