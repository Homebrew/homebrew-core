class Nut < Formula
  desc "Network UPS Tools: Support for various power devices"
  homepage "https://networkupstools.org/"
  url "https://github.com/networkupstools/nut/releases/download/v2.8.4/nut-2.8.4.tar.gz"
  sha256 "0130ba82ea79f04ba4f34c5249a85943977efd984ed7df6aec1a518d5a3594f8"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "7a95f6f8b57362fe1a44db874c3e153df30cc6d6d7a1a12b1a8e4c67cda1a7e0"
    sha256 arm64_sequoia: "3b1657b49d343f9be32b00c0a3058ce1c67723cf9b342462f7004cc0d15d5649"
    sha256 arm64_sonoma:  "dc00713e9a21615addbb2b1d97a3769947c584cabab38f9325b83a7b4317f375"
    sha256 sonoma:        "4865b9977f2d21a810a111e7d3d72f210f8081be30b19c1fe91be9dd8dc89303"
    sha256 arm64_linux:   "ad0050eafb34fdd77245bbc97e046c37f83c01e42e300c63e897adbd97ed9e05"
    sha256 x86_64_linux:  "2667c1b9ef3f1e6b2e3717f2241fd9b64a8cf0987274d49af7a4bc04d6804b9e"
  end

  head do
    url "https://github.com/networkupstools/nut.git", branch: "master"
    depends_on "asciidoc" => :build
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libusb"
  depends_on "openssl@3"

  on_linux do
    depends_on "systemd"
  end

  conflicts_with "rhino", because: "both install `rhino` binaries"

  def install
    if build.head?
      ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
      system "./autogen.sh"
    end

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --localstatedir=#{var}
      --sysconfdir=#{etc}/nut
      --with-statepath=#{var}/state/ups
      --with-pidpath=#{var}/run
      --with-systemdtmpfilesdir=#{pkgshare}
      --with-openssl
      --with-serial
      --with-usb
      --without-avahi
      --without-cgi
      --without-dev
      --without-doc
      --without-ipmi
      --without-libltdl
      --without-neon
      --without-nss
      --without-nut_monitor
      --without-powerman
      --without-pynut
      --without-snmp
      --without-wrap
    ]
    args << if OS.mac?
      "--with-macosx_ups"
    else
      "--with-udev-dir=#{lib}/udev"
    end

    system "./configure", *args
    system "make", "install"

    (var/"state/ups").mkpath
    (var/"run").mkpath
  end

  service do
    run [opt_sbin/"upsmon", "-D"]
  end

  test do
    system bin/"dummy-ups", "-L"
  end
end
