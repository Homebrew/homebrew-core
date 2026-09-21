class Lldpd < Formula
  desc "Implementation of IEEE 802.1ab (LLDP)"
  homepage "https://lldpd.github.io/"
  url "https://media.luffy.cx/files/lldpd/lldpd-1.0.22.tar.gz"
  sha256 "9587940ed2314a86774c5499f3dfb13a8eb86232a62d243a83a1f09886848e03"
  license "ISC"

  livecheck do
    url :homepage
    regex(/href=.*?lldpd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "885a3c65f7399c4826ec8645e279e8ff09451f6388ccbd2a4f0a196b7c2e7c4e"
    sha256 arm64_tahoe:       "d2be2c7719ff6b3746957f399214e34eb2866617e8bdfd78e032a49e8ffe835a"
    sha256 arm64_sequoia:     "46fa0dbea6c352bf58b1eb1c0d154ea8af222a37b64e483d0e80e0378e4a38bc"
    sha256 arm64_linux:       "e2ae49271b7bbd2fc2f21d867fe23e44efae7210e95f69641005b2526fe8edbe"
    sha256 x86_64_linux:      "6271b6f460a4a3079278be3222722b7c20758e03330800c44ff6025815813622"
  end

  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "readline"

  uses_from_macos "libxml2"

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-privsep-chroot=/var/empty
      --with-privsep-group=nogroup
      --with-privsep-user=nobody
      --with-readline
      --with-xml
      --without-launchddaemonsdir
      --without-snmp
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"

    (var/"run").mkpath
  end

  service do
    run opt_sbin/"lldpd"
    keep_alive true
    require_root true
  end
end
