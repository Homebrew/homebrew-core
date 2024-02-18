class Nut < Formula
  desc "Network UPS Tools: Support for various power devices"
  homepage "https://networkupstools.org/"
  url "https://github.com/networkupstools/nut/releases/download/v2.8.1/nut-2.8.1.tar.gz"
  sha256 "7da48ee23b1f0d8d72560bb0af84f5c5ae4dbe35452b84cb49840132e47f099c"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "e89241f392bb9fbbde389696485240a7113654b052272531ee06e5c5b05fc363"
    sha256 arm64_ventura:  "97fbfd94c5ffd011a35964ec70fa6be53fbbf77b47a2e279581bc4f65654b0c4"
    sha256 arm64_monterey: "d4bf0f41e9dac6c86f6ad87cd3478a7ccb7fbf09a3ede3ad9cff2561d05bc621"
    sha256 sonoma:         "5ae77de59c94f3c8f95ca59d56de5c709baf773d87c0ab2d30319f8a0e8a2b6a"
    sha256 ventura:        "39a83d05ae4ea2f34e03776749455f65c7daa845f04f8351a48bdae36d652c24"
    sha256 monterey:       "33acde657d811e6f9ca36ffe2041f814fe763f61e1723fe339b30b4229302223"
    sha256 x86_64_linux:   "bd17e0ea918ab4b2454c31d3a133fe116430530ce7dc55f4bb9dc98ef4e3cba8"
  end

  head do
    url "https://github.com/networkupstools/nut.git", branch: "master"
    depends_on "asciidoc" => :build
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"
  depends_on "openssl@3"

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
  end

  def post_install
    (var/"state/ups").mkpath
    (var/"run").mkpath
  end

  service do
    run [opt_sbin/"upsmon", "-D"]
  end

  test do
    system "#{bin}/dummy-ups", "-L"
  end
end
