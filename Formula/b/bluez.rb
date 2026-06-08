class Bluez < Formula
  desc "Bluetooth protocol stack for Linux"
  homepage "https://www.bluez.org"
  url "https://mirrors.edge.kernel.org/pub/linux/bluetooth/bluez-5.86.tar.xz"
  sha256 "99f144540c6070591e4c53bcb977eb42664c62b7b36cb35a29cf72ded339621d"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/linux/bluetooth/"
    regex(/href=.*?bluez[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_linux:  "c43c376469bbcfdd56921c23cd76fab1d46cd2afd1d4fd8e80e4fb1a47f3b694"
    sha256 x86_64_linux: "305929589b4f191eb10bb8110536500176a7d24a04f61bc90ae1a2bcca77ff17"
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
