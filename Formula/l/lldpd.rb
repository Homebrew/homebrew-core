class Lldpd < Formula
  desc "Implementation of IEEE 802.1ab (LLDP)"
  homepage "https://lldpd.github.io/"
  url "https://media.luffy.cx/files/lldpd/lldpd-1.0.17.tar.gz"
  sha256 "9343177f145d2bca66ef03d59528079d3f1663c624b1e2b9d08268efdc6127ce"
  license "ISC"

  livecheck do
    url "https://github.com/lldpd/lldpd.git"
  end

  bottle do
    sha256 arm64_sonoma:   "5f72fe07b466a3bc7f8d1d5204a4d5d9493954d7df43b9362628a451522e9f67"
    sha256 arm64_ventura:  "05359b24178b10a6d51b89d879da01150b073029943870917e4906ace804240a"
    sha256 arm64_monterey: "429752982f0ba472b97f95cf89e0c0a42109a0734a8643c22c87ff044a93b851"
    sha256 arm64_big_sur:  "a95b1e0fb11f67ef23e3a6e312e179813a00db6ac4c2a3133e43c543101cf644"
    sha256 sonoma:         "44873b7c7233cef7e3463bd3c0ed65ec18c4b12bd568f935649a1adadf9dd470"
    sha256 ventura:        "91e756817f4ae5a6c1a4cf15f4244aad4a610e9ccbd778093fc4e14ed8351c7f"
    sha256 monterey:       "182c26074eea41ab2b01627a8379f74b4232866f486643286c180e50371ee599"
    sha256 big_sur:        "d308af855f3bfa9c0b2ef7099406d21bf37c019200d372893904557977a2baab"
    sha256 x86_64_linux:   "3d31ed3f8699f0c3116047c90c26ff80a79bba6f6cb0555a2fb1d222f1bf7410"
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
