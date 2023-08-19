class Nut < Formula
  desc "Network UPS Tools: Support for various power devices"
  homepage "https://networkupstools.org/"
  license "GPL-2.0-or-later"
  revision 1

  stable do
    url "https://github.com/networkupstools/nut/releases/download/v2.8.0-signed/nut-2.8.0.tar.gz"
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
    sha256 arm64_ventura:  "2076a6fec70930a198b1ffc95372b783a953d893ed2531a704b8146014f6dda6"
    sha256 arm64_monterey: "95970abbffadbffea2a7135b6650179c35fdf6896188c8e4e2b426052521f506"
    sha256 arm64_big_sur:  "28d8de023cedfb15015a87d4bf8616ccff59b61c00918e652e82e55f4740bffc"
    sha256 ventura:        "191e4df438c669eed832fcdce481e3a527d835699431b757ed4dd29c81ae19ce"
    sha256 monterey:       "aa98d42f442ac810c3bb34341eefffa7893e5993934c57f4a95a43e9ac3fc001"
    sha256 big_sur:        "d41f1ed095ccbf5efc17b1710d8f222bb0f0b7cf343e411eae2cc58f3e3d26fc"
    sha256 x86_64_linux:   "da2d1bee4c97ef56f91023288452df6f5ea7744a0a9a75d907494c001aeea97a"
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
  depends_on "openssl@3"

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
