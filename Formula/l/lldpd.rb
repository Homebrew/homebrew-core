class Lldpd < Formula
  desc "Implementation of IEEE 802.1ab (LLDP)"
  homepage "https://lldpd.github.io/"
  url "https://media.luffy.cx/files/lldpd/lldpd-1.0.19.tar.gz"
  sha256 "f87df3163d5e5138da901d055b384009785d1eb50fdb17a2343910fcf30a997f"
  license "ISC"

  livecheck do
    url :homepage
    regex(/href=.*?lldpd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "59cc7f981a6fe7f35eb309d7fdeb5964015f051261c9a67cedb2cd55cdf58cda"
    sha256 arm64_sonoma:  "86793748eb50ee46faa3ba6243a46ddba2f12c5166d9d073483e32ee0c5082e9"
    sha256 arm64_ventura: "a05f4c8be6b40da8dbc10ec8275ecf4a070e4f3323b88f346f2af0a3915ad744"
    sha256 sonoma:        "56faf4f3d7d021301e0c4cfc3f3839392dcc60580eef6640aa95b9e1d06c67b9"
    sha256 ventura:       "d0512084df8dff94554d29f70d007b87ebb5bdd2c38828e5f5a5df35efdd247f"
    sha256 arm64_linux:   "4209af75c9145720691edc613bd7b2b739b42e1f43afb029966452be50e7e92f"
    sha256 x86_64_linux:  "95e2f798c865fa7e2bea24e503f66ec931e7851ab9146e2f4c0821de360fe8c8"
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
