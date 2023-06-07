class Nut < Formula
  desc "Network UPS Tools: Support for various power devices"
  homepage "https://networkupstools.org/"
  license "GPL-2.0-or-later"

  stable do
    url "https://github.com/networkupstools/nut/releases/download/v2.8.0/nut-2.8.0.tar.gz"
    sha256 "c3e5a708da797b7c70b653d37b1206a000fcb503b85519fe4cdf6353f792bfe5"

    # fix build failure
    # remove in next release
    patch do
      url "https://github.com/networkupstools/nut/commit/9e6d3c79a4c0ed71c25fdfd350402bb2e78e42e8.patch?full_index=1"
      sha256 "39472a04f1963a297713381a3a17e57183c1143a6602c194ca3016244caa6a9f"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "8b0272e6d6de21561ad76576e0c5a6817ece3d8a9667921f19c578cc5daff96e"
    sha256 arm64_monterey: "d4aca71123a29f19c2ef454498d9c42fa2e82f87cab985470f8245a6f0528247"
    sha256 arm64_big_sur:  "21a4e51be5f36088e2e1c1b882453de2b2ea367f6a5e477e58d28d4a0a842a78"
    sha256 ventura:        "987f9f114ec7d1d903b014552516b3bb6554b7c2e180c107819673ad936423ac"
    sha256 monterey:       "9bf13b79acc02f161664ae7995f427470a7e853abef9a8a0d1ca6aa6655fca12"
    sha256 big_sur:        "bc77e15ea9074a9f3c555f30f1eb60c2a8e718ae40290c47648493e771d7cb84"
    sha256 catalina:       "cd132007fa7178a543f11136afc85ae46dd98af743a23ed625d03c070b57f211"
    sha256 x86_64_linux:   "97499d28a03419960360fcf6445e5a1f7778d94d5072daf7b426af6d802d39f8"
  end

  head do
    url "https://github.com/networkupstools/nut.git", branch: "master"
    depends_on "asciidoc" => :build
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb-compat"
  depends_on "openssl@1.1"

  conflicts_with "rhino", because: "both install `rhino` binaries"

  def install
    if build.head?
      ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
      system "./autogen.sh"
    else
      # Regenerate configure, due to patch applied
      system "autoreconf", "-i"
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
      --without-powerman
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
