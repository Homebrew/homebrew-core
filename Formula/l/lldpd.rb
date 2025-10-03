class Lldpd < Formula
  desc "Implementation of IEEE 802.1ab (LLDP)"
  homepage "https://lldpd.github.io/"
  url "https://media.luffy.cx/files/lldpd/lldpd-1.0.20.tar.gz"
  sha256 "61b8cb22d4879e68f7825a2fb8e1e92abb4aba4773977cf0258bc32ed9f55450"
  license "ISC"

  livecheck do
    url :homepage
    regex(/href=.*?lldpd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "e1ad496e50ccec168747844a5f730a803987f539975f2a4ae02f2812b1c29de4"
    sha256 arm64_sequoia: "15dd2c95d8710eb6f5bff4a987743ef90153b4ebae141c95e17518fb90b5e0fd"
    sha256 arm64_sonoma:  "2b8909dc507549a6d2b92f0a39fb11a80493314d2eb38a8fa4c1dea8111a3c76"
    sha256 sonoma:        "987dc4b723aab6eac64564a3ab0cd92aabb552c7d686b028d01890e3118fd40a"
    sha256 arm64_linux:   "a79237b22b4c1a41a47c1071dd8834da8f6a955191d7e3064e3860fd48363f32"
    sha256 x86_64_linux:  "9f9fe3b9c2238c61f72d60f5bbc22cb66cba7f926517e5b3f1ba88c616ba17ed"
  end

  depends_on "pkgconf" => :build
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
