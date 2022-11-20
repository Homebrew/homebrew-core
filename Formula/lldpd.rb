class Lldpd < Formula
  desc "Implementation of IEEE 802.1ab (LLDP)"
  homepage "https://lldpd.github.io/"
  url "https://media.luffy.cx/files/lldpd/lldpd-1.0.16.tar.gz"
  sha256 "e3b391650c7ba67cea2fe84d67fdb4d7fc8aa1ec5cf86eb8bb984711df8465a9"
  license "ISC"

  livecheck do
    url "https://github.com/lldpd/lldpd.git"
  end

  bottle do
    sha256 arm64_ventura:  "ff11760e645aa9a58d077e5d8e416bf872fade71eb85d1a6a588b4f951f31302"
    sha256 arm64_monterey: "b8bf3e13786c2bc41f0e31625b4d00b2cbc7140187842efaa23cb461330e3308"
    sha256 arm64_big_sur:  "f9b3286480d22c400ad45081372b546f9c55e2874887f73019a6daa65e838b2a"
    sha256 ventura:        "6c665bd08df4671694d610a9c7ef64254175932b88e93b19f26d7de563648ef7"
    sha256 monterey:       "9030a1ab9ebea7663a223a87a6c7658a2eee34ca8554ae0c7df9911cc4d0206e"
    sha256 big_sur:        "8a228b47b5a500ecb8deff86506990ff320022de5dd4ebe747c1f6c7bce93987"
    sha256 catalina:       "a8717fa02414183918ab8e65840f1fafc94aacb0788ea97caf62203da3ded7cf"
    sha256 x86_64_linux:   "ca8dd7e5ed8b6491c2b71e637bec6b3e91c5430fdef4f68be30e9aeea49beba5"
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
