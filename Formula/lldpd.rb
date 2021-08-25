class Lldpd < Formula
  desc "Implementation of IEEE 802.1ab (LLDP)"
  homepage "https://lldpd.github.io/"
  url "https://media.luffy.cx/files/lldpd/lldpd-1.0.12.tar.gz"
  sha256 "d194c65b5b9c98d194a2842ddc75ba17ebdee7ebd5499f81a98d24031628daf1"
  license "ISC"

  livecheck do
    url "https://github.com/lldpd/lldpd.git"
  end

  bottle do
    sha256 arm64_big_sur: "8984826e95e004de9684e27686016a83ea79dd330dbfeb986ae1da382dfe9741"
    sha256 big_sur:       "1875a47b0f6c506e5e1589e61b939d6e6bb8849ba4e3da27f7e50951f12b802a"
    sha256 catalina:      "f7a97457480a6729c8fbe2360d0d8b3a3f8dbe55cbe05ae9e7ced15e5bd99d26"
    sha256 mojave:        "7727979d19df29e689f5ffea1921c5e8bcc9cecb86fd4623cd29d3c1d4912910"
    sha256 x86_64_linux:  "ba438cefa8414d35140c5eaebe36f6fa7abe8bdf3fa77245d48e8ab412f33c93"
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
