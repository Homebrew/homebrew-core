class Lldpd < Formula
  desc "Implementation of IEEE 802.1ab (LLDP)"
  homepage "https://lldpd.github.io/"
  url "https://media.luffy.cx/files/lldpd/lldpd-1.0.14.tar.gz"
  sha256 "a74819214f116a5dbc407a3d490caa01ba401a249517ac826a374059c12d12e8"
  license "ISC"

  livecheck do
    url "https://github.com/lldpd/lldpd.git"
  end

  bottle do
    sha256 arm64_monterey: "e38dc7af689d6ba5d788b72dd80a3951e677f6dae8e19d1f19474e94a00b1874"
    sha256 arm64_big_sur:  "2f7517a24567bedb8e41d679a598036813ac65ef9e564cc6aadcd413d124eafd"
    sha256 monterey:       "0cd69aa60c108adec0bb314151ffc795dbad90d221e2400e7a1f51f62dc1cbe0"
    sha256 big_sur:        "b9c878c316335861fa15cbd88b0e441a38f4c63fcca72fb447e173080c1c064b"
    sha256 catalina:       "b58ef47b12ee5c6c4f5d920052e0bbedf6d39f9b31d62f2cbf2feae7a4eefd52"
    sha256 x86_64_linux:   "ccaf742b1dc9107109c3dcaf0c600383f4fa6035840e06bb118a313b8b669337"
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "readline"

  uses_from_macos "libxml2"

  def install
    readline = Formula["readline"]
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-launchddaemonsdir=no
      --with-privsep-chroot=/var/empty
      --with-privsep-group=nogroup
      --with-privsep-user=nobody
      --with-readline
      --with-xml
      --without-snmp
      CPPFLAGS=-I#{readline.include}\ -DRONLY=1
      LDFLAGS=-L#{readline.lib}
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def post_install
    (var/"run").mkpath
  end

  plist_options startup: true
  service do
    run opt_sbin/"lldpd"
    keep_alive true
  end
end
