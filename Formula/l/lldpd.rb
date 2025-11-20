class Lldpd < Formula
  desc "Implementation of IEEE 802.1ab (LLDP)"
  homepage "https://lldpd.github.io/"
  url "https://media.luffy.cx/files/lldpd/lldpd-1.0.20.tar.gz"
  sha256 "61b8cb22d4879e68f7825a2fb8e1e92abb4aba4773977cf0258bc32ed9f55450"
  license "ISC"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?lldpd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "b06cc31ce05ecfd045b635377710710ec5fe085ed266004f8f7a37a8c5068326"
    sha256 arm64_sequoia: "ccc0e90f6d0d67978a0e374c5044e6fef2839f266c54e772d145c4bd5dc8c600"
    sha256 arm64_sonoma:  "b9ac85ce2d7637f6815b2909696b3ad42c3d0824b1152299810963b51b4f422d"
    sha256 sonoma:        "e9f70ec215c94aeb86b18d98358a11733b349a765aa0fe3af97da03ce66f16e2"
    sha256 arm64_linux:   "3381d8f39cc2ebbec18bd8feb89faccb7ca9db59569a7f5e7916b275ca223091"
    sha256 x86_64_linux:  "a439e92e0747bcce38853c64504e732088c53507fbe1f1a8346d868b957d7bc0"
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
