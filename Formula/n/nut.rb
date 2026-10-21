class Nut < Formula
  desc "Network UPS Tools: Support for various power devices"
  homepage "https://networkupstools.org/"
  url "https://github.com/networkupstools/nut/releases/download/v2.8.5/nut-2.8.5.tar.gz"
  sha256 "18bf32e59eb764b13da3c4fa70384926d7fa584cb31d2fe7f137a570633eeec1"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 arm64_golden_gate: "076a5c7afd045db536a83937ffbf2b92018a2e9d0f85f3d15dd0c2cb07339721"
    sha256 arm64_tahoe:       "6c21a836f940cae0738da89dfc631d6a78fe785788e1d694af658c97260053a3"
    sha256 arm64_sequoia:     "1f59e67ae5955118fe767371f8b4cfbe168e0fd56149f24c6d69f75832615f6a"
    sha256 arm64_linux:       "f68ec7f9ef05eb1353444eda6746ce98b37c03fc9829fd99aeed62024b1b4fec"
    sha256 x86_64_linux:      "719ed46ff2df25cfefd7dcea584891c08333a8a593ac08c301977810628a7c73"
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
  depends_on "openssl@4"

  on_linux do
    depends_on "glib"
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
    if OS.mac?
      args << "--with-macosx_ups"
    else
      args += %W[
        --with-udev-dir=#{lib}/udev
        --with-systemdsystemunitdir=#{lib}/systemd/system
        --with-systemdsystempresetdir=#{lib}/systemd/system-preset
        --with-systemdshutdowndir=#{lib}/systemd/system-shutdown
        --with-systemdsysusersdir=#{lib}/sysusers.d
      ]
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
