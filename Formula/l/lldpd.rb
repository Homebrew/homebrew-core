class Lldpd < Formula
  desc "Implementation of IEEE 802.1ab (LLDP)"
  homepage "https://lldpd.github.io/"
  url "https://media.luffy.cx/files/lldpd/lldpd-1.0.18.tar.gz"
  sha256 "4b320675d608901a4a0d4feff8f96bb846d4913d914b0cf75b7d0ae80490f2f7"
  license "ISC"

  livecheck do
    url "https://github.com/lldpd/lldpd.git"
  end

  bottle do
    sha256 arm64_sequoia:  "f9a5226fb9636d4d7ac0f611384d06761a1e79c6db4f1bbfdfad5a666850b65f"
    sha256 arm64_sonoma:   "1d55dfdc5fa76768424a820782b134945bef25af4f512e70b96a63948e44f24d"
    sha256 arm64_ventura:  "15f64e1ee4848e766401080882146fd250ac41feed01104f21bf849b95bbb679"
    sha256 arm64_monterey: "bfcce147acac721899e51388683ba20a747a51300981be6651f15a096371fabd"
    sha256 sonoma:         "6d3b544f3fa125ab6e3249c4a41e1f1c5013baef1ca379c1439f26960af131df"
    sha256 ventura:        "c76a1a426eb945a77945c4fa7908abfbfc886dcb189d923fcc9ef7b1c19496e2"
    sha256 monterey:       "c4f335a83f7a5bee626b6aa24347e98fcf2c27ec94f6172f3568ac8042a70969"
    sha256 x86_64_linux:   "4f8cb4e54dcf685cc00a0d6882f01c16e87584a2aef9742cb33a197e166be7b8"
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

  service do
    run opt_sbin/"lldpd"
    keep_alive true
    require_root true
  end
end
