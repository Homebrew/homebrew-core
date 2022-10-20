class Lldpd < Formula
  desc "Implementation of IEEE 802.1ab (LLDP)"
  homepage "https://lldpd.github.io/"
  url "https://media.luffy.cx/files/lldpd/lldpd-1.0.15.tar.gz"
  sha256 "f7fe3a130be98a19c491479ef60f36b8ee41a9e6bc4d7f2c41033f63956a3126"
  license "ISC"

  livecheck do
    url "https://github.com/lldpd/lldpd.git"
  end

  bottle do
    sha256 arm64_monterey: "17bee47c8191d50cda9323344213fd94ef1fc2d5e57a871fc7ec790a577e76c9"
    sha256 arm64_big_sur:  "a0eafc58c5a477c4bd559be2e5d8c9e9fdf9661e4680c44dd8f74bc95d8af040"
    sha256 monterey:       "fd15c6edc47b3be4579cfa000224b30b190da10551f2d7d1a57bc265048926e4"
    sha256 big_sur:        "798a6eccc979cf660be64ded7c214825ce9bd38da416ea14c9e504a4fd1c12dc"
    sha256 catalina:       "8cc43e0b0ae42857103e166d2fe67856a8bb747de9f32ee228919a6099d8b516"
    sha256 x86_64_linux:   "8692faf9d3e1b269f6a9686008dbe512cada3cb34a6f88b9c49521eff4e7a7ca"
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
